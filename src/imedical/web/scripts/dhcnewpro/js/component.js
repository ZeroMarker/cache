/**
 * Combobox
 * option 自定义Combobox参数设置
 */
var ListCombobox = function(id, url, data, option){
	this.id = id;
	this.url= url;
	this.data = data;
	this.option = option;
	}
	
ListCombobox.prototype.init = function(){
	
	var option = {
		url : this.url,
		data : this.data,
		valueField : 'value',    
		textField : 'text'
	}

	$('#'+this.id).combobox($.extend(option,this.option));
}

/*
 *	dategrid 
 *  option 自定义datagrid参数设置
 */
var ListComponent = function(id, columns, url, option){
 	this.id = id;
	this.url = url;
	this.option = option;
	this.columns = columns;
}

ListComponent.prototype.Init = function(){
	var option = {
		url : this.url,
		fit : true,
		striped : true, //是否显示斑马线效果
		columns : this.columns,
		pageSize : [30],
		pageList : [30,60,90],
		loadMsg : '正在加载信息...',
		rownumbers : true, //行号
		singleSelect : false,
		pagination : true,
		bordr : false,
		onBeforeLoad : function(param){
			///清空数据
			//$('#'+this.id).datagrid('loadData',{total:0,rows:[]});
		},
		onLoadSuccess:function(data){
			///提示信息
    		///LoadCellTip("");
		} 
	}
	$('#'+this.id).datagrid($.extend(option,this.option));
}

/*
 *	window 
 *  option 自定义window参数设置
 */
 
 var WindowUX = function(title, id, width, height, option){
 	this.title = title;
 	this.id = id;
 	this.width = width;
 	this.height = height;
 	this.option = option;
 }
 
 WindowUX.prototype.Init = function(){
	var option = {
		//closable : false,
		modal : true,
		inline : false,
		border : false,
		title : this.title,
		collapsible : false,
		//minimizable : false,
		//maximizable : false,
		width : this.width,
		height : this.height
	}
	$('#'+this.id).window($.extend(option,this.option));
	$('#'+this.id).window('open');
}

/*
 *	Dialog 
 *  option 自定义Dialog参数设置
 */
 
 var DialogUX = function(title, id, width, height, option){
 	 this.title = title;
 	 this.id = id;
 	 this.width = width;
 	 this.height = height;
 	 this.option = option;
 }
 
 DialogUX.prototype.Init = function(){
	var option = {
		//closable : false,
		modal : true,
		inline : false,
		border : false,
		title : this.title,
		collapsible : false,
		minimizable : false,
		maximizable : false,
		width : this.width,
		height : this.height
	}
	$('#'+this.id).dialog($.extend(option,this.option));
	$('#'+this.id).dialog('open');
}

/*
 *	Tree 
 *  option 自定义Dialog参数设置
 */
 
 var CusTreeUX = function(id, url, option){
 	 this.id = id;
 	 this.url = url;
 	 this.option = option;
 }
 
 CusTreeUX.prototype.Init = function(){
	var option = {
		url : this.url,
		multiple : true,
		lines: true,
		animate : true,   
		required : true
	}
	$('#'+this.id).tree($.extend(option,this.option));
}

/*
 *	TabUX 
 *  option 自定义TabUX参数设置
 */
 
 var TabsUX = function(title, id, option){
	 this.id = id;
 	 this.title = title;
 	 this.option = option;
 	 
 }
 
 TabsUX.prototype.Init = function(){
	var option = {
		border:false,
	    fit:"true"
	}
	$('#'+this.id).tabs($.extend(option,this.option));
}