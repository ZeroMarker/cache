﻿var _AColumns=""
$(function(){
	if(canBuildQueryCase == "N")
	{
		$("#btAddCondition").attr("style","display:none;");
		$("#btAddResultCol").attr("style","display:none;");
		$("#btnSaveCase").attr("style","display:none;");
		$("#btnModifyCase").attr("style","display:none;");
	}
	if ("undefined"==typeof HISUIStyleCode || HISUIStyleCode==""){
	 // 炫彩版
	 }else if (HISUIStyleCode=="lite"){
	 // 极简版
	 	$("#centerDiv").css("background-color", "#F5F5F5");
	 }else{
	// 炫彩版
	}
	
/* 	$("#btSimpleList").click(function(){
		$("#simpleString").css("display","none");
		$("#simpleList").css("display","block");
		
	});
	$("#btSimpleString").click(function(){
		$("#simpleList").css("display","none");
		$("#simpleString").css("display","block");
		$("#btSimpleList").removeClass("focus");		
	});
	*/
	
	$('#ListAndStringKeyWord').keywords({
        singleSelect:true,
        items:[
            {text:emrTrans('简单条件'),id:'btSimpleList',selected:true},
            {text:emrTrans('输入号串'),id:'btSimpleString'}
        ],
        onClick:function(v){
            toggleBtn(v.id);
        }
    });
		
	initSmipleCondition()
	initResultColums();
	initAdvancedCondition();
	initCombo();
	initLocView();
	//简单查询
	document.getElementById("btnCommit").onclick = function(){
		getResultData();
	}
	//结果列重置
	$("#btResetResultCol").click(function(){
		resetResultColums();
	});
	
	document.getElementById("btnCommitAdvanced").onclick = function(){
        //按钮只读，加载进度条
		setQueryButtonStatus(false);
		getAdvancedRequest();
	}	
	$("#resetSimpleCondition").click(function(){
		resetSmipleCondition();
	});		
	//
	$("#btResetCondition").click(function(){
		resetAdvancedCondition();
	});		
	//添加条件
	$("#btAddCondition").click(function(){
		//window.showModalDialog("epr.query.hisui.popwin.csp?Action=condition",window,"dialogHeight:500px;dialogWidth:608px;resizable:no;status:no");
		var content = "<iframe id='addCondition' name='addCondition' scrolling='auto' frameborder='0' src='epr.query.hisui.popwin.csp?Action=condition&DialogId=dialogDiv&canViewAllLoc="+canViewAllLoc+"' style='height:100%;width:100%;display:block;'></iframe>"
		createModalDialog("dialogDiv","添加条件","630","600","addCondition",content);
	});	
	//添加结果
	$("#btAddResultCol").click(function(){
		//returnValues = window.showModalDialog("epr.query.hisui.popwin.csp?Action=result",window,"dialogHeight:500px;dialogWidth:608px;resizable:no;status:no");
		var content = "<iframe id='addResultCol' name='addResultCol' scrolling='auto' frameborder='0' src='epr.query.hisui.popwin.csp?Action=result&DialogId=dialogDiv' style='height:100%;width:100%;display:block;'></iframe>"
		createModalDialog("dialogDiv","添加结果","630","600","addResultCol",content);
	});
	//后台任务列表
	$("#btnTaskList").click(function(){
		var content = "<iframe id='taskList' scrolling='auto' frameborder='0' src='epr.query.hisui.tasklist.csp' style='height:100%;width:100%;display:block;'></iframe>"
		createModalDialog("dialogTaskList","任务列表","1200","600","taskList",content);
	});
	//添加任务
	$("#btnAddTask").click(function(){
		var content = "<iframe id='addTask' scrolling='auto' frameborder='0' src='epr.query.hisui.taskaddrecord.csp' style='height:100%;width:100%;display:block;'></iframe>"
		createModalDialog("dialogAddTask","添加任务","320","157","addTask",content,addTaskCallBack,"");
	});
	//打开方案列表弹出框
	$("#btnSelectCase").click(function(){
		//returnValues = window.showModalDialog("epr.query.hisui.popwincaselist.csp",window,"dialogHeight:500px;dialogWidth:608px;resizable:no;status:no");
		var content = "<iframe id='selectCase' name='selectCase' scrolling='auto' frameborder='0' src='epr.query.hisui.popwincaselist.csp?DialogId=dialogDiv' style='height:100%;width:100%;display:block;'></iframe>"
		createModalDialog("dialogDiv","选择已有方案","614","560","selectCase",content);
	});
	//打开保存方案弹出框
	$("#btnSaveCase").click(function(){
		//returnValues = window.showModalDialog("epr.query.hisui.popwincase.csp?saveType=save",window,"dialogHeight:500px;dialogWidth:608px;resizable:no;status:no");
		var content = "<iframe id='saveCase' name='saveCase' scrolling='auto' frameborder='0' src='epr.query.hisui.popwincase.csp?saveType=save&DialogId=dialogDiv' style='height:100%;width:100%;display:block;'></iframe>"

		createModalDialog("dialogDiv","保存方案","1020","625","saveCase",content);
	});
	//打开修改方案弹出框
	$("#btnModifyCase").click(function(){
		if (tempStore.ID == "")
		{
			$.messager.alert("提示信息", "请先读取已有方案再修改！","alert");
		}
		else{
			if (tempStore.SaveUserID != userID )
			{
				$.messager.alert("提示信息", "您不是该方案的保存者，无权修改此方案！","alert");
			}
			else {
				//returnValues = window.showModalDialog("epr.query.hisui.popwincase.csp?saveType=modify",window,"dialogHeight:500px;dialogWidth:608px;resizable:no;status:no");
				var content = "<iframe id='modifyCase' name='modifyCase' scrolling='auto' frameborder='0' src='epr.query.hisui.popwincase.csp?saveType=modify&DialogId=dialogDiv' style='height:100%;width:100%;display:block;'></iframe>"
			
				createModalDialog("dialogDiv","修改方案","1020","625","modifyCase",content);
			}
		}
	});
	
	$('#txtValue0').combobox({
		onSelect: function(record){
			if (record.id == "I")
			{
				var data =[
					{
						"id":"O&EPR^AdmDate^AdmDate^date^1",
						"text":emrTrans("就诊日期"),
						"selected":true		
					},
					{
						"id":"I&EPR^DischDate^DischDate^date^1",
						"text":emrTrans("出院日期")		
					}
				]
			}
			else
			{
				var data =[
					{
						"id":"O&EPR^AdmDate^AdmDate^date^1",
						"text":emrTrans("就诊日期"),
						"selected":true		
					}
				]
			}
			$('#name1').combobox('loadData',data);
			$('#name2').combobox('loadData',data);
		}
	});
	
},0);﻿

///切换页签
function toggleBtn(tabId)
{
    if (tabId == "btSimpleList")
    {
	  	$("#simpleString").css("display","none");
		$("#simpleList").css("display","block");
    }
    else
    {
	  	$("#simpleList").css("display","none");
		$("#simpleString").css("display","block");
		$("#btSimpleList").removeClass("focus");
    }
    
}
function initCombo()
{
	$HUI.combobox("#cbxRegType",{width:'154'});
	$HUI.combogrid("#cbxLoc",{width:'154'});
	$HUI.combogrid("#cbxWard",{width:'154'});
	$HUI.datebox("#dtAdmBeginDate",{width:'154'});
	$HUI.datebox("#dtAdmEndDate",{width:'154'});
	$HUI.datebox("#dtDisBeginDate",{width:'154'});
	$HUI.datebox("#dtDisEndDate",{width:'154'});
}

function initSmipleCondition()
{
	$HUI.combobox("#cbxRegType",{
		valueField:'id', 
		textField:'text', 
		panelHeight:"auto",
		data:getEpisodeType()
	});
	
	$HUI.combobox("#cbxNumberType",{
		valueField:'id', 
		textField:'text', 
		panelHeight:"auto",
		data:getNumberType()
	});	
	setDic("cbxLoc","S07");
	setDic("cbxWard","S10");
}

function resetSmipleCondition()
{
	$('#cbxLoc').combogrid('clear');
	$('#cbxWard').combogrid('clear');
	$('#cbxRegType').combobox('clear');
	$('#txtRegNo').val('');
	$('#txtEpisodeNo').val('');
	$('#MedicareNo').val('');
	$('#txtDiagnose').val('');
	$('#txtPatientName').val('');
	$('#numbers').val('');
	$('#dtAdmBeginDate').datebox('clear');
	$('#dtAdmEndDate').datebox('clear');
	$('#dtDisBeginDate').datebox('clear');
	$('#dtDisEndDate').datebox('clear');
}

function setDic(id,dicNum)
{
	$HUI.combogrid("#"+id,{
		idField:"Id", 
		textField:"Text", 
		fitColumns:true,
		pagination:true,
		panelWidth: 430,
		url:"../EMRservice.Ajax.hisData.cls?Action=GetDicList&DicCode="+dicNum+"&PageType=current&LoadType=combogrid",
		columns: [[
	        {field:"Id",hidden:true},
			{field:"Alias",hidden:true},
	        {field:"Code",hidden:true},
            {field:"Text",width:400}
        ]],
        keyHandler:{
            up: function() {},
            down: function() {},
            enter: function() {},
            query: function(q) {
                //动态搜索
               $("#"+id).combogrid("grid").datagrid("reload", {"Action":"GetDicList","DicCode":dicNum,"Condition":q,"PageType":"current","LoadType":"combogrid"});
               $("#"+id).combogrid("setValue", q);
            }
        }
	});		
}
function initResultColums()
{
	jQuery.ajax({
		type: "post",
		dataType: "json",
		url: "../web.eprajax.query.basicsetting.cls",
		async: true,
		data: {
			Action:"getDefaultHISItems",
		},
		success: function(d) {
				var item = "";
                for (var i = 0; i < d.length; i++) {
	                var itemID = "ResultColsCheck" + $("#divResultCols").find("input").length;
					if (d[i]["Code"].split('^')[2] == 'EpisodeNo' || d[i]["Code"].split('^')[2] == 'EpisodeID' || d[i]["Code"].split('^')[2] == 'AdmType')
					{
						item = getStrResultColum(true,d[i]["Code"],itemID,d[i]["Title"]); 
						
					}
					else 
					{
						item = getStrResultColum(false,d[i]["Code"],itemID,d[i]["Title"]); 
					}
					$("#divResultCols").append(item);
                }
                $.parser.parse("#divResultCols");
                setResultData();
		},
		error : function(d) { $.messager.alert("简单提示", "error", 'info');}
	});		
}

function getStrResultColum(status,value,id,desc)
{
	var	item = '<div class="resultcolum"><input class="hisui-checkbox" type="checkbox" data-options="checked:true,disabled:'+status+'" value="'+value+'" id="'+id+'" label="'+desc+'"/></div>';
	return item;
}

function resetResultColums()
{
	//定义结果列重置
	$("#divResultCols").find("input:not(:checked)").parents("div[id='divResultCols'] div").remove();
	setResultData();
}

function setResultColums(items)
{
    var divColumns = $("#divResultCols"); 
	$.each(items, function(index,item) {
		var itemID = "ResultColsCheck" + $("#divResultCols").find("input").length;
		var code = item.cateType + "^" + item.code;
		var title = item.cateName + "." + item.title;
		//var find = $("#divResultCols").find("input[value='"+code+"']");
		var find = $("#divResultCols").find("input[label='"+title+"']")
		if (find.length <= 0)
		{
			var col = getStrResultColum(false,code,itemID,title);
			$("#divResultCols").append(col);
		}
		else
		{
			$.messager.alert("简单提示", "添加的结果列有重复，已将其过滤！", 'info');
		}		
	})
	$.parser.parse("#divResultCols");
	setResultData();  
}

function readCaseResultCols(ResultColsStr)
{
	//定义结果列重置
	$("#divResultCols").find("input").parents("div[id='divResultCols'] div").remove();
	
	var ResultColsNum = ResultColsStr.split(",")[0];
	var i=1,j=2,k=3;
	for (i=1; i<=ResultColsNum;i=i+3)
	{
		var status = false;
		var IsDisabled = ResultColsStr.split(",")[i];
		var ColsName = ResultColsStr.split(",")[j];
		var ColsCode = ResultColsStr.split(",")[k];
		j=j+3,k=k+3;
		
		if (IsDisabled == "Y")
		{
			status = true;
		}
		var itemID = "ResultColsCheck" + $("#divResultCols").find("input").length;
		var col = getStrResultColum(status,ColsCode,itemID,ColsName);
		$("#divResultCols").append(col);
	}
	$.parser.parse("#divResultCols");
	setResultData();
}

function setResultData()
{
	var cols = getResultCol();
	$('#dgResultGrid').datagrid({
		headerCls:'panel-header-gray',
		pagination:true,
		rownumbers:true,
		border:false,
		pageSize:20,
		total:1,
		fit:true,
		data:[], 
	    columns:[cols.columns],
	    onLoadSuccess:function(){
		    setQueryButtonStatus(true);
		} 
	});	
}


///取结果列
function getResultCol()
{
	var colResult = new Array();
	var hiddenCol = "";
	
	var StatusCol = {
		field:'TStatus',title:'操作',width:45,resizable:false,align:'center',formatter: function(value,row,index){
			var html = '<div>';
			
			var title = "病历浏览";
			var style="display:block;width:100%;";
			if (row["EpisodeID"]!="")
			{
				if((HISUIStyleCode)&&(HISUIStyleCode=="lite"))
				{
					style += "background:url(../skin/default/images/read.png) center center no-repeat;"
				}
				else
				{
					style += "background:url(../skin/default/images/read.png) center center no-repeat;"
				}
				html = html + '<span title="'+title+'" style="'+style+'" onclick = recordBrowser(' + row["EpisodeID"] + ');>&nbsp;&nbsp;</span>';
			}
			
			html = html + '</div>';
			return html;
		},styler:function(value,row,index){
			return "cursor:pointer ;";
		}
	};
	colResult.push(StatusCol);
    
	var arrInput = $("#divResultCols").find("input:checked");
	$.each(arrInput,function(i,item)
	{
		 hiddenCol = hiddenCol + item.value + "&";
	     var itemArr = item.value.split("^");
	     var tmpcol = {field:itemArr[1],title:itemArr[3]};
	     colResult.push(tmpcol);
	});
	hiddenCol = hiddenCol.substring(0,hiddenCol.length-1);
	_AColumns=hiddenCol;
	var result = {"columns":colResult,"columnstr":hiddenCol};
	return result
}

function recordBrowser(EpisodeID)
{
	//window.showModalDialog("emr.browse.emr.csp?EpisodeID=" + EpisodeID + "&ViewType=Editor",window,"dialogWidth:1200px;dialogHeight:600px;resizable:yes;status:no;maximize:yes;");
	var sheight = screen.height-120;
	var swidth = screen.width-60;
	var winoption ="dialogHeight:"+sheight+"px;dialogWidth:"+ swidth +"px;status:yes;scroll:yes;resizable:yes;center:yes";
	//var url = "websys.chartbook.hisui.csp?PatientListPanel=emr.browse.episodelist.csp&PatientListPage=emr.browse.patientlist.csp&SwitchSysPat=N&ChartBookName=DHC.Doctor.DHCEMRbrowse&EpisodeID="+EpisodeID
	//window.showModalDialog(url,"",winoption);
	var content = "<iframe id='patientBrowser' name='patientBrowser' scrolling='auto' frameborder='0' src='websys.chartbook.hisui.csp?PatientListPanel=emr.browse.episodelist.csp&PatientListPage=emr.browse.patientlist.csp&SwitchSysPat=N&ChartBookName=DHC.Doctor.DHCEMRbrowse&EpisodeID="+EpisodeID+"&MWToken="+getMWToken()+"' style='width:"+swidth+"px;height:"+(sheight-80)+"px;display:block;'></iframe>"
	createModalDialog("DialogDiv","病历浏览",swidth,sheight,"patientBrowser",content);
}

function getNameData()
{
	var data =[
		{
			"id":"O&EPR^AdmDate^AdmDate^date^1",
			"text":emrTrans("就诊日期"),
			"selected":true		
		},
		/*
		{
			"id":"I&EPR^AdmDate^AdmDate^date^1",
			"text":"入院日期",
			"selected":true
		},
		*/
		{
			"id":"I&EPR^DischDate^DischDate^date^1",
			"text":emrTrans("出院日期")		
		}
	]
	return data;
}

function getOPData()
{
	var data =[ 
		{"id":">","text":emrTrans("大于")},
		{"id":"<","text":emrTrans("小于")},
		{"id":"=","text":emrTrans("等于"),"selected":true},
		{"id":"<>","text":emrTrans("不等于")},
		{"id":"<=","text":emrTrans("不大于")},
		{"id":">=","text":emrTrans("不小于")},
		{"id":"like","text":emrTrans("包含")},
		{"id":"notlike","text":emrTrans("不包含")}
	]
	return data;	
}

function getRelation()
{
	var data =[ 
		{"id":"&&&","text":emrTrans("并且"),"selected":true},
		{"id":"|||","text":emrTrans("或者")}
	]
	return data;	
}
//高级查询固定就诊类型，需要“全部”选项
function getAdmTypeData()
{
	var data = 
	[
		{"id":"I","text":emrTrans("住院")},
		{"id":"O","text":emrTrans("门诊")},
		{"id":"E","text":emrTrans("急诊")},
		{"id":"ALL","text":emrTrans("全部")}
	]
	return data;
}
//简单查询就诊类型
function getEpisodeType()
{
	var data = 
	[
		{"id":"I","text":emrTrans("住院")},
		{"id":"O","text":emrTrans("门诊")},
		{"id":"E","text":emrTrans("急诊")},
		{"id":"H","text":emrTrans("体检")}
	]
	return data;
}

function getNumberType()
{
	var data = [
		{"id":"admNo","text":emrTrans("就诊号"),"selected":true},
		{"id":"patNo","text":emrTrans("登记号")},
		{"id":"medNo","text":emrTrans("病案号")}	
	]
	return data;
}

function getResultData()
{
	var cols = getResultCol();
	var param = getSimpContions();
	if (param == "")
	{
		return;
	}
    //加载进度条
    setQueryButtonStatus(false);
	jQuery.ajax({
		type: "post",
		dataType: "json",
		url: '../web.eprajax.query.basicquery.cls?frameType=HISUI&canViewAllLoc=' + canViewAllLoc,
		async: true,
		data:param,
		success: function(d) 
		{
			$("#hiddenSimpleGUID").text(d.GUID);
			var girdParam = {
				action:'fetchdata',
				hiddenGUID:d.GUID,
				hiddenCols:cols.columnstr
			}
			$('#dgResultGrid').datagrid("options").url  = '../web.eprajax.query.basicquery.cls?frameType=HISUI&canViewAllLoc=' + canViewAllLoc;
			$('#dgResultGrid').datagrid('load', girdParam);
			//$('#btnCommit').linkbutton('enable');
		},
		error : function(d) { $.messager.alert("简单提示", "error", 'info'); setQueryButtonStatus(true);}
	});	
}


function getSimpContions()
{
	var submitValues ={};
	if ($("#simpleString").css("display") != "none")
	{
		if ($("#numbers").val() == "")
		{
		  $.messager.alert("提示信息", "号串内容不能为空！","alert"); 
		  return "";
		}
		var numberType = $('#cbxNumberType').combobox('getValue');

		if (numberType == "admNo")
		{
		submitValues.txtEpisodeNo = $("#numbers").val();
		}
		else if(numberType == "patNo")
		{
		  submitValues.txtRegNo = $("#numbers").val();
		}
		else if(numberType == "medNo")
		{
		  submitValues.MedicareNo = $("#numbers").val();
		}
        
        if (canViewAllLoc == "N") {submitValues.locID = ctLocID;}
	}	
	else
	{
		submitValues.txtPatientName = $("#txtPatientName").val();
		submitValues.txtRegNo = setRegNoLength($("#txtRegNo").val());
		submitValues.MedicareNo = $("#MedicareNo").val();
		submitValues.txtEpisodeNo = $("#txtEpisodeNo").val();
		submitValues.cbxRegType = $('#cbxRegType').combobox('getValue');
		submitValues.txtDiagnose = $("#txtDiagnose").val();
		submitValues.locID = $('#cbxLoc').combogrid('getValue');
		if (canViewAllLoc == "N") {submitValues.locID = ctLocID;}
		submitValues.wardID = $('#cbxWard').combogrid('getValue');
		submitValues.dtAdmBeginDate = dateFormat($("#dtAdmBeginDate").datebox('getValue'));
		submitValues.dtAdmEndDate = dateFormat($("#dtAdmEndDate").datebox('getValue'));
		submitValues.dtDisBeginDate = dateFormat($("#dtDisBeginDate").datebox('getValue'));
		submitValues.dtDisEndDate = dateFormat($("#dtDisEndDate").datebox('getValue'));
		var validInfo = validateSimpleRequest(submitValues);
		if( !validInfo[0])
		{
			$.messager.alert("提示信息", validInfo[1],"alert"); 
			return "";	
		}
	}
	submitValues.action = "querydata";
	return submitValues;	
}


function setRegNoLength(regNo)
{
	var m_RegNoLength=10;
	
	if (regNo!='') 
	{
		if (regNo.length<m_RegNoLength)
		{
			for (var i=(m_RegNoLength-regNo.length-1); i>=0; i--)
			{
				regNo="0"+regNo;
			}
		}
	}
	return regNo;
}

//数据校验///////////////////////////////////////////////
//Desc:     客户端验证简单查询条件
//Params:   submitValues为简单查询条件键值对
//Return:   一个数组（第一项代表是否合法，第二项为错误信息）
function validateSimpleRequest(submitValues) {
    var result = [];
    var isValid = true;
    var errMessage = "";

    var patientName = submitValues["txtPatientName"];
    var regNo = submitValues["txtRegNo"];
	var MedicareNo = submitValues["MedicareNo"];
    var episodeNo = submitValues["txtEpisodeNo"];
	var diagnose = submitValues["txtEpisodeNo"];
    var admBeginDate = submitValues["dtAdmBeginDate"];
    var admEndDate = submitValues["dtAdmEndDate"];
    var disBeginDate = submitValues["dtDisBeginDate"];
    var disEndDate = submitValues["dtDisEndDate"];
    
    if (patientName == "" && regNo == "" && MedicareNo == "" && episodeNo == "" && admBeginDate == "" && admEndDate == "" && disBeginDate == "" && disEndDate == "" && diagnose == "") 
    {
        isValid = false;
        errMessage = "至少指定一个或一组查询条件!";
    } 
    else if (patientName == "" && regNo == "" && MedicareNo == "" && episodeNo == "" && diagnose == "") 
    {
        var isUseAdmit = (admBeginDate != ""&&admEndDate != "")||(admBeginDate == "" && admEndDate == "");
        var isUseDisch = (disBeginDate != ""&&disEndDate != "")||(disBeginDate == "" && disEndDate == "");
        if (!(isUseAdmit && isUseDisch)) {
            isValid = false;
            errMessage = "入院或出院起始截止日期必须成对出现!";
        }
    }
    if (admBeginDate != "" && !regDate(admBeginDate)) 
    {
        isValid = false;
        errMessage = "入院起始日期格式不正确，正确格式为YYYY-MM-DD";
    }
    if (admEndDate != "" && !regDate(admEndDate)) 
    {
        isValid = false;
        errMessage = "入院起始日期格式不正确，正确格式为YYYY-MM-DD";
    }
    if (admBeginDate != "" && admEndDate != "") 
    {
		if (DateCompare(admEndDate, admBeginDate) == false) 
		{
            isValid = false;
            errMessage = "入院截止日期不能小于入院起始日期";
        }
        else if (dateDiff(admEndDate, admBeginDate) > queryDateGap) 
        {
            isValid = false;
            errMessage = "入院日期间隔不能超过系统指定的" + queryDateGap + "天";
        }
    }
    
    if (disBeginDate != "" && !regDate(disBeginDate)) 
    {
        isValid = false;
        errMessage = "出院起始日期格式不正确，正确格式为YYYY-MM-DD";
    }
    if (disEndDate != "" && !regDate(disEndDate)) 
    {
        isValid = false;
        errMessage = "出院起始日期格式不正确，正确格式为YYYY-MM-DD";
    }
    if (disBeginDate != "" && disEndDate != "") 
    {
		if (DateCompare(disEndDate, disBeginDate) == false) 
		{
            isValid = false;
            errMessage = "出院截止日期不能小于出院起始日期";
        }
        else if (dateDiff(disEndDate, disBeginDate) > queryDateGap) 
        {
            isValid = false;
            errMessage = "出院日期间隔不能超过系统指定的" + queryDateGap + "天";
        }
    }
    result[0] = isValid;
    result[1] = errMessage;
    return result;
}
//Desc: 正则表达式判断日期是否合法
function regDate(ctrlValue) {
    var reg = /^((((1[6-9]|[2-9]\d)\d{2})-(0?[13578]|1[02])-(0?[1-9]|[12]\d|3[01]))|(((1[6-9]|[2-9]\d)\d{2})-(0?[13456789]|1[012])-(0?[1-9]|[12]\d|30))|(((1[6-9]|[2-9]\d)\d{2})-0?2-(0?[1-9]|1\d|2[0-8]))|(((1[6-9]|[2-9]\d)(0[48]|[2468][048]|[13579][26])|((16|[2468][048]|[3579][26])00))-0?2-29))$/;
    if (reg.test(ctrlValue)) 
        return true;
    return false;
}

//Desc: 正则表达式判断时间是否合法
function regTime(ctrlValue) {
    var reg = /^([0-1][0-9]|(2[0-3])):([0-5][0-9]):([0-5][0-9])$/;
    if (reg.test(ctrlValue))
        return true;
    return false;
}

//Desc:     判断两个日期之间的间隔天数
//Params:   sDate1和sDate2是2002-12-18格式
function dateDiff(sDate1, sDate2) {               
    var aDate, oDate1, oDate2, iDays
    aDate = sDate1.split("-")
    oDate1 = new Date(aDate[1] + '-' + aDate[2] + '-' + aDate[0])               //转换为12-18-2002格式      
    aDate = sDate2.split("-")
    oDate2 = new Date(aDate[1] + '-' + aDate[2] + '-' + aDate[0])
    iDays = parseInt(Math.abs(oDate1 - oDate2) / 1000 / 60 / 60 / 24)           //把相差的毫秒数转换为天数
    if (iDays < 0) {
        return -iDays;
    } 
    return iDays
} 

//Desc:     判断两个日期大小关系，
//返回true：Date1晚于或等于Date2
//返回false：Date1早于Date2
//Params:   Date1和Date2是2002-12-18格式
function DateCompare(Date1, Date2) {
    var aDate, bDate
    aDate = Date1.split("-");
	bDate = Date2.split("-");
	if ((aDate[0] - bDate[0]) < 0)
	{
		return false;
	}
	else if ((aDate[0] - bDate[0]) == 0)
	{
		if ((aDate[1] - bDate[1]) < 0)
		{
			return false;
		}
		else if ((aDate[1] - bDate[1]) == 0)
		{
			if ((aDate[2] - bDate[2]) < 0)
			{
				return false;
			}
			else
			{
				return true;
			}
		}
		else
		{
			return true;
		}
	}
	else
	{
		return true;
	}
} 
///高级查询////////////////////////////////////////////////////////////////////////////////
//Desc: 初始化高级查询条件
function initAdvancedCondition() 
{
    var table = $('#tblCondition');
    var tr = setTrCondition("0","true","str","","","str",emrTrans("就诊类型"),"HIS^AdmType^AdmType^str^1","str","=",emrTrans("等于"),"selectAdmType")
	$(table).append(tr);
	var tr = setTrCondition("1","true","str","&&&",emrTrans("并且"),"select","","","str",">",emrTrans("大于"),"date");
	$(table).append(tr);
	var tr = setTrCondition("2","true","str","&&&",emrTrans("并且"),"select","","","str","<",emrTrans("小于"),"date");
	$(table).append(tr);
	$.parser.parse('#tblCondition');
	$.parser.parse();
}

function resetAdvancedCondition()
{
	//高级查询重置按钮事件
	var trs = $("#tblCondition input").val("");
	var trs = $("#tblCondition >div:nth-child(n+4)").remove();

}

var arrRules = new Array();
function addAdvacedCondition(conditions)
{
	var table = $('#tblCondition');
	var arrDic = new Array();
	$.each(conditions, function(index,item) {
		var curIndex = $("#tblCondition .row-item-big-long").length;
		var code = item.code
		var title = item.title;
		var cateType = item.cateType;
		var info = code.split("^");
        var itemCode = cateType + "^" + info[0] + "^" + info[1] + "^" + info[3] + "^" + info[4];
        var valType = info[3]
        if (info[4] != "1") valType = "select"
		var tr = setTrCondition(curIndex,"false","select","","","str",title,itemCode,"select","","",valType)
		$(table).append(tr);
		arrRules=new Array();
		if (valType == "select")
		{
			arrDic.push({"id":"txtValue"+curIndex,"dic":info[4]});
		}
		if (info[5] !== "" && info[5] !== undefined)
		{
			var rules = info[5].split("_")
			arrRules.push({"id":"txtValue"+curIndex,"eventType":rules[0],"eventName":rules[1],"parameters":rules[2]});
			addRules(arrRules);
		}
		$.parser.parse('#row'+curIndex);
		$.parser.parse('#row'+curIndex);
	});
	loadDics(arrDic);
}

function readAdvacedCondition(conditionStr)
{
	clearAdvancedCondition();  // 读取成功后，删除页面当前显示的查询条件
	//添加读取到的查询条件
	var table = $('#tblCondition');
	var arrDic = new Array();
	var conditionNum = conditionStr.split(",")[0];
	var i=1,j=2,k=3,m=4,n=5;
	for (i=1; i<=conditionNum;i=i+5)
	{
		var curIndex = $("#tblCondition .row-item-big-long").length;
		
		var setORCode = conditionStr.split(",")[i];
		var setItemCode = conditionStr.split(",")[j];
		var setItemName = conditionStr.split(",")[k];
		var setOPCode = conditionStr.split(",")[m];
		var settxtValue = conditionStr.split(",")[n];
		j=j+5,k=k+5,m=m+5,n=n+5;
		
		if (i < 15)
		{
			if (i == 1)
			{
				var tr = setTrCondition(curIndex,"true","str","","","str",emrTrans("就诊类型"),"HIS^AdmType^AdmType^str^1","str","=",emrTrans("等于"),"selectAdmType")
				$(table).append(tr);
				$.parser.parse('#row'+curIndex);
				$('#txtValue' + curIndex).combobox('setValue', settxtValue);
			}
			else if (i == 6)
			{
				var tr = setTrCondition(curIndex,"true","str","&&&",emrTrans("并且"),"select","","","str",">",emrTrans("大于"),"date");
				$(table).append(tr);
				$.parser.parse('#row'+curIndex);
				$('#name' + curIndex).combobox('select',setItemCode);
				$('#txtValue' + curIndex).datebox('setValue', settxtValue);
			}
			else if (i == 11)
			{
				var tr = setTrCondition("2","true","str","&&&",emrTrans("并且"),"select","","","str","<",emrTrans("小于"),"date");
				$(table).append(tr);
				$.parser.parse('#row'+curIndex);
				$('#name' + curIndex).combobox('select',setItemCode);
				$('#txtValue' + curIndex).datebox('setValue', settxtValue);
			}
		}
		else if (i>15)
		{
			var info = setItemCode.split("^");
	        var valType = info[3];
	        if (info[4] != "1") valType = "select";
			var tr = setTrCondition(curIndex,"false","select","","","str",setItemName,setItemCode,"select","","",valType)
			$(table).append(tr);
			$.parser.parse('#row'+curIndex);
			
			$('#relation' + curIndex).combobox('select',setORCode);
			$('#op' + curIndex).combobox('select',setOPCode);

			if (valType == "date")
			{
				$('#txtValue' + curIndex).datebox('setValue', settxtValue);
			}
			else if (valType == "time")
			{
				$('#txtValue' + curIndex).timespinner('setValue', settxtValue);
			}
			else if (valType == "select")
			{
				var dicNum = info[4];
				setDic("txtValue"+curIndex,dicNum);
				
				$("#txtValue"+curIndex).combogrid("grid").datagrid("reload", {"DicCode":dicNum,"DicQuery":settxtValue,"Type":"HISUI"});
               	$("#txtValue"+curIndex).combobox("setValue", settxtValue);
			}
			else
			{
				$('#txtValue' + curIndex).val(settxtValue);
			}
		}
	}
	return "Y";
}

function loadDics(arrDic)
{
	$.each(arrDic, function(index,item) {
		setDic(item.id,item.dic);
	});
}

function setTrCondition(curIndex,checkboxStatus,relationType,relationCode,relationValue,nameType,nameValue,nameCode,opType,opCode,opValue,valueType)
{
	var parDiv = $('<div class="row-item-big-long" id="row'+curIndex+'"></div>');
	if ((canViewAllLoc == "N")&&((nameValue.indexOf("科室") != -1)||(nameValue.indexOf("病区") != -1)))
	{
		var tdcheckFlag = false;
		checkboxStatus = true;
	}
	else
	{
		var tdcheckFlag = true;
	}
	$(parDiv).append('<div class="tdcheckbox row-item-short-input1"><input name="condition" class="hisui-checkbox" data-options="disabled:'+checkboxStatus+',checked:'+tdcheckFlag+'" id="checkbox'+curIndex+'" type="checkbox"></div>');
	
	if (relationType == "str")
	{
		$(parDiv).append('<div class="tdrelation row-item-short-input2" style="padding-top:4px"><label id="relation'+curIndex+'" code="'+relationCode+'">'+relationValue+'</label></div>');
	}
	else
	{
		$(parDiv).append('<div class="tdrelation row-item-short-input2"><input id="relation'+curIndex+'" class="hisui-combobox" data-options="width:65,panelHeight:'+"'auto'"+',valueField:'+"'id'"+',textField:'+"'text'"+',data:getRelation()"></input></div>');		
	}
	if (nameType == "select")
	{
		$(parDiv).append('<div class="tdcolname row-item-short-input3"><input id="name'+curIndex+'" class="hisui-combobox colname" data-options="panelHeight:'+"'auto'"+',valueField:'+"'id'"+',textField:'+"'text'"+',data:getNameData()"></input></div>');
	}
	else
	{
		$(parDiv).append('<div class="tdcolname row-item-short-input3" style="padding-top:4px"><label id="name'+curIndex+'" code="'+nameCode+'">'+nameValue+'</label></div>');
	}
	if (opType == "str")
	{
		$(parDiv).append('<div class="tdop row-item-short-input4" style="padding-top:4px"><label id="op'+curIndex+'" code="'+opCode+'">'+opValue+'</label></div>');
	}
	else
	{
		$(parDiv).append('<div class="tdop row-item-short-input4"><input id="op'+curIndex+'" class="hisui-combobox" data-options="width:70,panelHeight:'+"'auto'"+',valueField:'+"'id'"+',textField:'+"'text'"+',data:getOPData()"></input></div>');
	}
	if (valueType == "date")
	{
		$(parDiv).append('<div class="tdop row-item-short-input5"><input id="txtValue'+curIndex+'" class="hisui-datebox boxvalue"/></div>');
	}
	else if (valueType == "time")
	{
		$(parDiv).append('<div class="tdop row-item-short-input5"><input id="txtValue'+curIndex+'" class="hisui-timespinner boxvalue"/></div>');
	}
	else if (valueType == "select")
	{
		$(parDiv).append('<div class="row-item-short-input5"><input id="txtValue'+curIndex+'" class="hisui-combobox boxvalue"/></div>');
	}
	else if (valueType == "selectAdmType")
	{
		$(parDiv).append('<div class="row-item-short-input5"><input id="txtValue'+curIndex+'" class="hisui-combobox boxvalue" data-options="valueField:'+"'id'"+',textField:'+"'text'"+',data:getAdmTypeData()"></input></div>');
	}
	else
	{
		$(parDiv).append('<div class="row-item-short-input5"><input id="txtValue'+curIndex+'" class="textbox"/></div>');
	}
	return parDiv;
}


///取高级查询结果
function getAdvancedRequest()
{
	var arrAdvancedCondition = getAdvancedConditions();
	if (!arrAdvancedCondition[0]) 
	{
		 $.messager.alert("提示信息", arrAdvancedCondition[1],"alert");
		 setQueryButtonStatus(true);
		 return;
	}
	var cols = getResultCol();
	//$('#btnCommitAdvanced').linkbutton('disable');
	var tmpGUID = ""
	jQuery.ajax({
		type: "post",
		dataType: "json",
		url: '../web.eprajax.query.advancedquery.cls?frameType=HISUI&canViewAllLoc=' + canViewAllLoc,
		async: true,
		data:{action: 'getGUID', hiddenGUID: $("#hiddenAdvancedGUID").text()},
		success: function(d) 
		{
			if (d.GUID != "")
			{
				$("#hiddenAdvancedGUID").text(d.GUID);
				tmpGUID = d.GUID;
				var k=0;       
				var curnum=0;  
				querydataToTempGlobal(k,tmpGUID,arrAdvancedCondition,cols.columnstr);		
				//记录日志
				var resultColumnArr = cols.columnstr.split("&");
				var resColDesc = "";
				$.each(resultColumnArr,function(i,item)
				{
					var itemArr = item.split("^");
					resColDesc = resColDesc+"/"+itemArr[3];
				});	//获取结果列
				if (arrAdvancedCondition[3] == "DischDate"){taskConditions = "出院日期"+taskConditions;}else{taskConditions = "入院日期"+taskConditions;}
				setQueryLog("../web.eprajax.query.medicalquerytask.cls","EMR.Query.View",arrAdvancedCondition[3],taskConditions,resColDesc)	
			}
		},
		error : function(d) { $.messager.alert("简单提示", "error", 'info'); setQueryButtonStatus(true);}
	});	
	
}

var taskConditions = "";
function getAdvancedConditions(action) {
	var resulstContion = new Array();
    resulstContion[0] = false;
    resulstContion[1] = "";    
    var length = $("#tblCondition .row-item-big-long").length;
    var itemCode1 = $("#name1").combobox("getValue");
    itemCode1 = itemCode1.substring(2);
	var relationCode1 = document.getElementById("relation1").getAttribute("code");
	var opCode1 = document.getElementById("op1").getAttribute("code");
	var itemCode2 = $("#name2").combobox("getValue");
	itemCode2 = itemCode2.substring(2); 
	var relationCode2 = document.getElementById("relation2").getAttribute("code");
	var opCode2 = document.getElementById("op2").getAttribute("code");
	var fromDate = $("#txtValue1").datebox('getValue');
	fromDate = dateFormat(fromDate);
	var toDate = $("#txtValue2").datebox('getValue');
	toDate = dateFormat(toDate);    
    var check = checkValue(length,fromDate,toDate,itemCode1,itemCode2);
    if (!check[0])
    {
        resulstContion[1] = check[1];
        return resulstContion;
    }
	resulstContion[2] = new Array();
	var selectGap = 3;
	var gap = dateDiff(toDate, fromDate);
    var iEnd = parseInt(gap/selectGap);
    resulstContion[0] = true;
    var tmpFromDate = fromDate;
    var i = 0;
    taskConditions = "大于"+fromDate+"并且小于"+toDate;
    var tmpCondition = getCondition(length);
    if (action !== "addTask")
    {
	    while(i<iEnd-1)
	    {
			tmpToDate = stringDateAdd(tmpFromDate,selectGap-1);
			resulstContion[2][i] = "$" + opCode1 + "$" + tmpFromDate + relationCode1 + "$" + opCode2 + "$" + tmpToDate + tmpCondition;
			tmpFromDate = stringDateAdd(tmpToDate,1);
			i = i + 1;		
	    }    
	}
    resulstContion[2][i] = "$" + opCode1 + "$" + tmpFromDate + relationCode2 + "$" + opCode2 + "$" + toDate + tmpCondition;
    resulstContion[3] = itemCode1.split("^")[1];
    return resulstContion;
}
///检查数据
function checkValue(length,fromDate,toDate,itemCode0,itemCode1){
	var arrCheck = new Array();
	arrCheck[0]= false;
	var queryType0 = itemCode0.split("^")[1];
	var queryType1 = itemCode1.split("^")[1];
	if (queryType0 != queryType1)
	{
		arrCheck[1] = "查询条件前两个必须成对出现！"
		return arrCheck;
	};
	var gap = dateDiff(toDate, fromDate);
    if (gap > queryDateGap) 
    {
        arrCheck[1] = "日期间隔不能超过系统指定的" + queryDateGap + "天";
        return arrCheck;
    }	
	var txtValue = "",itemCode = "", itemType = "";label = "";
	arrCheck[0] = true;
	for (var i = 1; i < length; i++) 
	{
		if (!document.getElementById("checkbox" + i).checked) continue;
		if (i == 1) 
		{
			itemCode = itemCode0;
			label = $("#name" + i).combobox("getText")
			txtValue = fromDate; 
		} else if (i==2)
		{
			itemCode = itemCode1;
			label = $("#name" + i).combobox("getText")
			txtValue = toDate;  
		} else 
		{ 
			itemCode = document.getElementById("name" + i).getAttribute("code");
			label = document.getElementById("name" + i).innerText;
	        var arrItiemCode = itemCode.split("^");
	        if (arrItiemCode[4] != 1)
	        {
		        txtValue = $("#txtValue" + i).combobox("getText");
		    }
		    else
		    {
			    if (arrItiemCode[3] == "date")
			    {
				    txtValue = $("#txtValue" + i).datebox("getValue");
				    txtValue = dateFormat(txtValue);
				}
				else if (arrItiemCode[3] == "time")
				{
					txtValue = $("#txtValue" + i).timespinner("getValue");
				}
				else
				{
					txtValue = $("#txtValue" + i).val();
				}
			}			
		}
        
		if (txtValue == "" || txtValue =="请输入信息" || txtValue == "请选择日期" || txtValue == "请选择"  ) 
		{
			arrCheck[0] = false;
			arrCheck[1] = label + "值域不能为空!";
			break;
		}
		//转换约定的空值
		if (txtValue == "NULL") {txtValue = "";}
		if (!regSpecial(txtValue)) 
		{
			arrCheck[0] = false;
			arrCheck[1] = label + "中有特殊字符!";
			break;
		}
			itemType = itemCode.split("^")[3];
			if (itemType == "date" && !regDate(txtValue)) 
			{
				arrCheck[0] = false;
				arrCheck[1] = label + "不合法或格式不正确，必须为YYYY-MM-DD格式!";
				break;
			}
	} 
    return arrCheck;
}

///取条件
function getCondition(length){ 
	var strCondition = "";
    var relationCode = "", itemCode = "", opCode = "", txtValue = "", itemType = "";    
    for (var i = 0; i < length; i++) 
    {
	    if((i == 1)||(i == 2)) continue;
		if(!document.getElementById("checkbox" + i).checked) continue;
		itemCode = document.getElementById("name" + i).getAttribute("code");
		if (i == 0)
		{
			relationCode = "&&&";
			opCode = "=";
			txtValue = $("#txtValue" + i).combobox("getValue");
			if (txtValue == "ALL")
			{
				opCode = "<>";
			}
		}
		else
		{
			relationCode = $("#relation" + i).combobox("getValue");
			opCode = $("#op" + i).combobox("getValue");
	        var arrItiemCode = itemCode.split("^");
	        if (arrItiemCode[4] != 1)
	        {
		        txtValue = $("#txtValue" + i).combobox("getText");
		    }
		    else
		    {
			    if (arrItiemCode[3] == "date")
			    {
				    txtValue = $("#txtValue" + i).datebox("getValue");
				    txtValue = dateFormat(txtValue);
				}
				else if (arrItiemCode[3] == "time")
				{
					txtValue = $("#txtValue" + i).timespinner("getValue");
				}
				else
				{
					txtValue = $("#txtValue" + i).val();
				}
			}
		}
		if(i == 0)
		{
			taskConditions = taskConditions + "并且就诊类型等于" + $("#txtValue"+i).combobox("getText")
		}
		else
		{
			taskConditions = taskConditions+$("#relation"+i).combobox("getText")+document.getElementById("name" + i).innerText+$("#op"+i).combobox("getText")+txtValue;
      	}
		strCondition = strCondition + relationCode + itemCode + "$" + opCode + "$" + txtValue;
     }
     
     if (canViewAllLoc == "N")
     {
	    strCondition = strCondition + "&&&HIS^AdmDept^AdmDept^str^S07$=$"+ ctLocDesc; 
     }
     
     return strCondition 
}

function stringDateAdd(strValue,adddata ){     
    var arr = strValue.split("-");   
    var newdt = new Date(Number(arr[0]),Number(arr[1])-1,Number(arr[2])+ adddata);   
    repnewdt = newdt.getFullYear() + "-" +   (newdt.getMonth()+1) + "-" + newdt.getDate();   
    return repnewdt;   
}

//Desc: 正则表达式判断是否包含特殊字符
function regSpecial(ctrlValue) {
    var reg = /[@#\$%\^&\*]+/g;
    if (reg.test(ctrlValue)) {
        return false;
    }
    return true;
}

function querydataToTempGlobal(k,tmpGUID,arrAdvancedCondition,resultStrCols)
{
	jQuery.ajax({
		type: "post",
		dataType: "text",
		url: '../web.eprajax.query.advancedquery.cls?frameType=HISUI&canViewAllLoc=' + canViewAllLoc,
		async: true,
		data:{
			action: 'querydata', 
			hiddenGUID:tmpGUID,
			conditions:arrAdvancedCondition[2][k],
			hiddenCols:resultStrCols,
			queryType: arrAdvancedCondition[3] 
		},
		success: function(d) 
		{
			if (d == "WriteTempGlobalOver")
			{	
				k = k + 1;
				if (k < arrAdvancedCondition[2].length)
				{	
					querydataToTempGlobal(k,tmpGUID,arrAdvancedCondition,resultStrCols)
				}
				else
				{
					getRusultStore(tmpGUID,resultStrCols);
				}
			}
		},
		error : function(d) { $.messager.alert("简单提示", "advanced error", 'info'); setQueryButtonStatus(true);}
	});		
}

function getRusultStore(tmpGUID,resultStrCols)
{
	var girdParam = {
		action:'fetchdata',
		hiddenGUID:tmpGUID,
		hiddenCols:resultStrCols
	}

	$('#dgResultGrid').datagrid("options").url  = '../web.eprajax.query.advancedquery.cls?frameType=HISUI';
	$('#dgResultGrid').datagrid('load', girdParam);
	//$('#btnCommitAdvanced').linkbutton('enable');
}

function clearAdvancedCondition()
{
	//刷新时高级查询条件清空
	var trs = $("#tblCondition").find("input[name='condition']").parents(".row-item-big-long").remove();
	
}
//回车不全登记号txtRegNo
$('#txtRegNo').bind('keypress', function(event) {
	if (event.keyCode == "13") {
		setTxtRegNoLength();
	}
});
function setTxtRegNoLength(){
	var txtRegNo = $("#txtRegNo").val();
	if (txtRegNo != '') 
	{
		if (txtRegNo.length < 10) 
		{
			for (var i=(10-txtRegNo.length-1); i>=0; i--)
			{
				txtRegNo ="0"+ txtRegNo;
			}
		}
	}
	$("#txtRegNo").val(txtRegNo);
}


//高级查询添加事件
function addRules(arrRules){
	$.each(arrRules, function(index,item) {
		$('#'+item.id).bind(item.eventType,item,eval(item.eventName))
	});
}
//位数不够补零
function zeroPadding(event) {
	if (event.keyCode == "13") {
		var txtValue = $("#"+event.data.id).val();
		if (txtValue !== ''){
			if (txtValue.length < event.data.parameters)
			{
				for (var i=(event.data.parameters-txtValue.length-1); i>=0; i--)
				{
					txtValue = '0'+txtValue;
				}
			}
		}
		$("#"+event.data.id).val(txtValue);
	}
}
/*function addDigital(event) {
	console.log(event);
}*/

var type="all";
//导出数据
function exportData(){
	
	var ev=window.event;
	var searchType =ev.currentTarget.id;
	var date = new Date();
	var title = userCode+"-"+date.getTime();
	
			
	if (searchType=="advanceExcel")
	{	
		var guid = $("#hiddenAdvancedGUID").text();
	}else{
		var guid = $("#hiddenSimpleGUID").text();		
	}
	if(guid==undefined || guid =="")
	{
		$.messager.alert("提示信息", "请先查询数据","alert"); 
		return	
	}
	$('#advanceExcel').linkbutton('disable');
	$('#simpleExcel').linkbutton('disable');
	if(type=="all"){
		var params =guid+","+_AColumns
		jQuery.ajax({
		type: "post",
		dataType: "text",
		url: "../EMRservice.Ajax.common.cls",
		async: true,
		data: {
			"OutputType":"String",
			"Class":"EMRservice.Tools.ExportToExcel",
			"Method":"toExcelByEMR",
			"p1":title,
			"p2":"web.eprajax.query.basicquery",
			"p3":"getExcelData",
			"p4":params
			
		},
		success: function(d) {
				var flag = d.substring(0,1);
				if(flag=="w"){
					location.href=d;
				}	
				$('#advanceExcel').linkbutton('enable');
				$('#simpleExcel').linkbutton('enable');	
		},
		error : function(d) { 
			alert("导出EXCEL错误");
			$('#advanceExcel').linkbutton('enable');
			$('#simpleExcel').linkbutton('enable');	
		}
		});
	}else{
		var pageObject = $('#dgResultGrid').datagrid('getPager').data("pagination").options;
		var page=pageObject.pageNumber;
		var size=pageObject.pageSize;
		var params =guid+","+_AColumns+","+page+","+size
		jQuery.ajax({
		type: "post",
		dataType: "text",
		url: "../EMRservice.Ajax.common.cls",
		async: true,
		data: {
			"OutputType":"String",
			"Class":"EMRservice.Tools.ExportToExcel",
			"Method":"toExcelByEMR",
			"p1":title,
			"p2":"web.eprajax.query.basicquery",
			"p3":"getExcelData",
			"p4":params
			
		},
		success: function(d) {
				var flag = d.substring(0,1);
				if(flag=="w"){
					location.href=d;
				}
				$('#advanceExcel').linkbutton('enable');
				$('#simpleExcel').linkbutton('enable');	
		},
		error : function(d) { 
			alert("导出EXCEL错误");
			$('#advanceExcel').linkbutton('enable');
			$('#simpleExcel').linkbutton('enable');	
		}
		});
	}
}
//导出当前页和所有
function selectHandler(obj){
	type=obj.value;	
}
$("#main").tabs({
	onSelect:function(title,index){
		if (title=="高级查询"){
			$("#simpleExportDiv")[0].style.display="none";
			$("#advanceExportDiv")[0].style.display="block";
			$HUI.combobox("#exportAdvance",{
				valueField:'val', 
				textField:'text', 
				panelWidth:"80",
				data:[
					{val:"all",text:emrTrans("导出全部")},
					{val:"current",text:emrTrans("导出当前页")}
				],
				onSelect:function(obj){
					type=obj.val;	
				},
				onLoadSuccess:function(){
						$HUI.combobox("#exportAdvance").setValue(emrTrans("导出全部"));
						type="all";
				}
			});
		}else{
			$("#simpleExportDiv")[0].style.display="block";
			$("#advanceExportDiv")[0].style.display="none";
			$HUI.combobox("#exportSimple",{
				valueField:'val', 
				textField:'text', 
				panelWidth:"80",
				data:[
					{val:"all",text:emrTrans("导出全部")},
					{val:"current",text:emrTrans("导出当前页")}
				],
				onSelect:function(obj){
					type=obj.val;	
				},
				onLoadSuccess:function(){
						$HUI.combobox("#exportSimple").setValue(emrTrans("导出全部"));
						type="all";
				}
			});
		}	
	}
})

function addTaskCallBack(returnValue,arr)
{
	if (returnValue == "") return;
	jQuery.ajax({
		type: "post",
		dataType: "json",
		url: '../web.eprajax.query.advancedquery.cls?frameType=HISUI',
		async: true,
		data:{action: 'getGUID', hiddenGUID: ""},
		success: function(d) 
		{
			if (d.GUID != "")
			{
				var cols = getResultCol();
				var arrAdvancedCondition = getAdvancedConditions("addTask");
				if (!arrAdvancedCondition[0]) 
				{
					 $.messager.alert("提示信息", arrAdvancedCondition[1],"alert"); 
					 return;
				}
				jQuery.ajax({
					type: "post",
					dataType: "text",
					url: "../EMRservice.Ajax.common.cls",
					async: true,
					data: {
						"OutputType":"",
						"Class":"EPRservice.BLL.Query.BLMedicalQueryTasklist",
						"Method":"InsertInfo",
						"p1":returnValue,
						"p2":userID,
						"p3":userName,
						"p4":d.GUID,
						"p5":arrAdvancedCondition[2][0],
						"p6":taskConditions,
						"p7":cols.columnstr,
						"p8":arrAdvancedCondition[3]
					},
				});
				
				//创建任务时记录日志
				var resultColumnArr = cols.columnstr.split("&");
				var resColDesc = "";
				$.each(resultColumnArr,function(i,item)
				{
					var itemArr = item.split("^");
					resColDesc = resColDesc+"/"+itemArr[3];
				});	//获取结果列
				var url = "../web.eprajax.query.medicalquerytask.cls";
				if (arrAdvancedCondition[3] == "DischDate"){taskConditions = "出院日期"+taskConditions;}else{taskConditions = "入院日期"+taskConditions;}
				setQueryLog(url,"EMR.Query.Task.Create",arrAdvancedCondition[3],taskConditions,resColDesc);
			}
		},
		errot: function(){alert("getGUID ERROR!");}
	})
	
	
}

//记录日志
function setQueryLog(url,actionType,dateType,conditions,resultCol)
{
	var ipAddress = getIpAddress();
	jQuery.ajax({
		type : "GET",
		dataType : "text",
		url : url,
		async : true,
		data : {
			"actionType":actionType,
			"userID":userID,
			"userName":userName,
			"ipAddress":ipAddress,			//当前ip
			"dateType":dateType,			//日期类型
			"conditions":conditions,		//条件描述
			"resultCol":resultCol			//结果列
		}
	});	
}

function initLocView()
{
	if (canViewAllLoc == "N")
	{
		$('#cbxLoc').combogrid('disable');
		$('#cbxWard').combogrid('disable');
	}
}

//显示、隐藏进度条，按钮控制是否只读
function setQueryButtonStatus(flag) {
	if (!flag){
		$('#btnCommitAdvanced').linkbutton('disable');
		$('#btnCommit').linkbutton('disable');
		$.messager.progress({
			title:"提示",
			msg:"正在查询...",
			text:"正在查询..."
			
		});	
	}
	else
	{
		$('#btnCommitAdvanced').linkbutton('enable');
		$('#btnCommit').linkbutton('enable');
		$.messager.progress("close");
	}
}