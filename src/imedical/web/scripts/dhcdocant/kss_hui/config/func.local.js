/**
 * localconfig.hui.js 本地化参数设置
 * 
 * Copyright (c) 2018-2019 QiuPeng. All rights reserved.
 * 
 * CREATED BY QP 2018-08-10
 * 
 * 注解说明：
 */
 
//页面全局变量
var PageLogicObj = {
	m_Grid : "",
	m_Hosp: "",
	m_DG_Hosp:"",
	m_DG_Pro:"",
	m_Win : ""
	
}

$(function(){
	
	//初始化
	Init();
	
	//事件初始化
	InitEvent();
	
	//页面元素初始化
	PageHandle();
})

function Init(){
	PageLogicObj.m_Grid = InitGrid();
	InitHospList();
}
function InitEvent(){
	$("#i-find").click(findConfig);
	$("#i-add").click(function(){opDialog("add")});
	$("#i-edit").click(function(){opDialog("edit")});
	$("#i-content").keydown(function (event) {
        if (event.which == 13) {
            findConfig();
        }
    });
	$(document.body).bind("keydown",BodykeydownHandler)
}

function PageHandle(){
	//
}

function InitHospList() {
	PageLogicObj.m_Hosp = GenHospComp("Ant_Config_Func_LocalSet");
	PageLogicObj.m_Hosp.jdata.options.onSelect = function(rowIndex,data){
		findConfig();
	}
	PageLogicObj.m_Hosp.jdata.options.onLoadSuccess= function(data){
		findConfig();
	}
}

function InitGrid(){
	var columns = [[
		{field:'productLine',title:'产品线',width:80},
		{field:'cfgCode',title:'配置代码',width:50},
		{field:'cfgName',title:'配置名称',width:80},
		{field:'cfgValue',title:'配置数值',width:50},
		{field:'cfgNote',title:'配置说明',width:100},
		{field:'cfgHospDesc',title:'院区',width:100}
    ]]
	var DurDataGrid = $HUI.datagrid("#i-durGrid", {
		fit : true,
		border : false,
		striped : true,
		singleSelect : true,
		fitColumns : true,
		rownumbers:true,
		//autoRowHeight : false,
		pagination : true,  
		headerCls:'panel-header-gray',
		//pageSize:14,
		//pageList : [14,20,50],
		url:$URL,
		queryParams:{
			ClassName : "DHCAnt.KSS.Config.LocalConfig",
			QueryName : "QryPara",
			SearchContent: ""
		},
		columns :columns,
		toolbar:[{
				text:'添加',
				id:'i-add',
				iconCls: 'icon-add'
			},{
				text:'修改',
				id:'i-edit',
				iconCls: 'icon-edit'
			}
		]
	});
	
	return DurDataGrid;
}

//编辑或新增
function opDialog(action) {
	var selected = PageLogicObj.m_Grid.getSelected();
	var tempValue = "",tempValue2 = "";
	var _title = "", _icon = "" ;
	if (action == "add") {
		_title = "添加";
		_icon = "icon-w-add";
		$("#dg-action").val("add");
		$("#dg-id").val("");
	} else {
		if (!selected) {
			$.messager.alert("提示","请选择一条记录...","info")
			return false;
		}
		_title = "修改";
		_icon = "icon-w-edit";
		$("#dg-action").val("edit");
	}
	
	if($('#i-dialog').hasClass("c-hidden")) {
		$('#i-dialog').removeClass("c-hidden");
	};

	PageLogicObj.m_DG_Pro = $HUI.combobox("#dg-pro", {
		url:$URL+"?ClassName=DHCAnt.KSS.Config.LocalConfig&QueryName=QryProductLine&ResultSetType=array",
		valueField:'code',
		textField:'name'
	});

	if (action == "add") {
		$("#dg-procode").val("");
		$("#dg-proname").val("");
		$("#dg-code").val("");
		$("#dg-name").val("");
		$("#dg-value").val("");
		$("#dg-note").val("");
		
	} else {
		$("#dg-code").val(selected.cfgCode);
		$("#dg-name").val(selected.cfgName);
		$("#dg-value").val(selected.cfgValue);
		$("#dg-note").val(selected.cfgNote);
		PageLogicObj.m_DG_Pro.setValue(selected.productCode);
	}
	$("#dg-name").validatebox("validate");
	$("#dg-code").validatebox("validate");
	var cWin = $HUI.window('#i-dialog', {
		title: _title,
		iconCls: _icon,
		modal: true,
		minimizable:false,
		maximizable:false,
		maximizable:false,
		collapsible:false,
		onClose: function () {
			//$(this).window('destroy');
			$('#i-dialog').addClass("c-hidden");
		}
	});
	
	PageLogicObj.m_Win = cWin;
}

function deConfig () {
	var selected = PageLogicObj.m_Grid.getSelected();
	if (!selected) {
		$.messager.alert("提示","请选择一条记录...","info")
		return false;
	}
	$.m({
			ClassName:"web.DHCDocExtData",
			MethodName:"DeleteExtData",
			MUCRowid: selected.HidRowid
		},function (responseText){
			if(responseText == 0) {
				$.messager.alert('提示','删除成功',"info");
				PageLogicObj.m_Grid.reload();
			} else {
				$.messager.alert('提示','修改失败,错误代码: '+ responseText , "info");
				return false;
			}	
		})
}


//保存字典信息
function saveCfg() {
	var action = $("#dg-action").val();
	var proCode = PageLogicObj.m_DG_Pro.getValue()||"";
	var proName = PageLogicObj.m_DG_Pro.getText();
	var code = $.trim($("#dg-code").val());
	var name = $.trim($("#dg-name").val());
	var value = $.trim($("#dg-value").val());
	var note = $.trim($("#dg-note").val());
	var hosp = getHosp();
	var paraInStr = name + "^" + value + "^" + note + "^" + hosp;
	if (proCode == "") {
		$.messager.alert('提示','产品线不能为空!',"info");
		return false;
	}
	if ((code == "")||(name == "")) {
		$.messager.alert('提示','配置代码和配置描述不能为空!',"info");
		return false;
	}
	/* if (value == "") {
		$.messager.alert('提示','配置数值不能为空!',"info");
		return false;
	}*/
	if (hosp == "") {
		$.messager.alert('提示','院区不能为空!',"info");
		return false;
	}  
	var hasCfg = $.m({
		ClassName:"DHCAnt.KSS.Config.LocalConfig",
		MethodName:"HasLocalConfig",
		procode:proCode,
		code:code
	},false);
	var oldCode = "", oldProcode = "";

	if (action == "edit") {
		var selected = PageLogicObj.m_Grid.getSelected();
		oldCode = selected.cfgCode;
		oldProcode = selected.productCode;
		var oldProline = selected.productLine;
		var newProline = proName; 	//+ "（" + proCode  + "）";
		var msg = "";
		if ( (oldProcode != proCode)  && (hasCfg == 1) )  {
			msg = "您所修改的配置（<span class='c-tip'>" + code + "</span>）在产品线【" + newProline + "】下已经存在，继续会覆盖该配置，并且会删除原有产品线【" + oldProline + "】下的（<span class='c-old'>"+ oldCode +"</span>）配置，是否继续？";
		}
		if ( (oldProcode != proCode)  && (hasCfg == 0) )  {
			msg = "您即将会在产品线【" + newProline + "】下，新增（<span class='c-tip'>" + code + "</span>）配置，但是会删除原有产品线【" + oldProline + "】下（<span class='c-old'>"+ oldCode +"</span>）配置，是否继续？";
		}
		if ( (oldProcode == proCode) && (oldCode != code) && (hasCfg == 1) ) {
			oldProcode = "";
			msg = "您即将所修改产品线【" + oldProline + "】下配置代码（<span class='c-tip'>" + code + "</span>）已经存在，如果继续将覆盖之前的（<span class='c-old'>"+ code +"</span>）该配置，并且会删除（<span class='c-old'>" + oldCode + "</span>）配置，是否继续？";
		}
		if ( (oldProcode == proCode) && (oldCode != code) && (hasCfg == 0) ) {
			oldProcode = "";
			msg = "您即将所修改产品线【" + oldProline + "】下配置代码（<span class='c-tip'>" + code + "</span>）会替换掉（<span class='c-old'>" + oldCode + "</span>）配置，是否继续？";
		}
		if (msg != "") {
			$.messager.confirm("提示", msg, function (r) {
				if (r) {
					SaveLocalConfig(proCode,code,paraInStr,action,oldCode,oldProcode)
				} 
			});
		} else {
			SaveLocalConfig(proCode,code,paraInStr,action,"","");
		}
		
	} else {
		if (hasCfg == 1) {
			$.messager.alert('提示',"此配置已存在！" , "info");
			return false;
		}
		SaveLocalConfig(proCode,code,paraInStr,action,oldCode,oldProcode);
	}
}

function SaveLocalConfig(proCode,code,paraInStr,action,oldCode,oldProcode) {
	$.m({
		ClassName:"DHCAnt.KSS.Config.LocalConfig",
		MethodName:"SaveLocalConfig",
		procode:proCode,
		code:code,
		para:paraInStr,
		action:action,
		oldcode:oldCode,
		oldProcode:oldProcode
	},function (responseText){
		if(responseText == 0) {
			$.messager.alert('提示','保存成功!',"info");
			PageLogicObj.m_Win.close();
			PageLogicObj.m_Grid.reload();
			
		} else if (responseText == "-2") {
			$.messager.alert('提示',"配置已存在" , "info");
			return false;
		} else {
			$.messager.alert('提示','保存失败,错误代码: '+ responseText , "info");
			return false;
		}
	})
}

//查找
function findConfig () {
	var SearchContent = $("#i-content").val();
	var InHosp = getHosp();
	PageLogicObj.m_Grid.reload({
		ClassName : "DHCAnt.KSS.Config.LocalConfig",
		QueryName : "QryPara",
		SearchContent: SearchContent,
		InHosp:InHosp
	});
}

function getHosp () {
	if (PageLogicObj.m_Hosp == "") {
		return session['LOGON.HOSPID'];
	} 
	var InHosp = PageLogicObj.m_Hosp.getValue()||""
	if (InHosp == "") {
		InHosp = session['LOGON.HOSPID'];
	}
	return InHosp;
}

function BodykeydownHandler(e){
	if (window.event){
		var keyCode=window.event.keyCode;
		var type=window.event.type;
		var SrcObj=window.event.srcElement;
	}else{
		var keyCode=e.which;
		var type=e.type;
		var SrcObj=e.target;
	}
	//浏览器中Backspace不可用  
   var keyEvent;   
   if(e.keyCode==8){   
       var d=e.srcElement||e.target;
        if(d.tagName.toUpperCase()=='INPUT'||d.tagName.toUpperCase()=='TEXTAREA'){   
            keyEvent=d.readOnly||d.disabled;   
        }else{   
            keyEvent=true;   
        }   
    }else{   
        keyEvent=false;   
    }   
    if(keyEvent){   
        e.preventDefault();   
    }   
}


