// Create By ZX 2017-03-22 ComboGrid元素调用封存插件
// 调用方式 jQuery("#useloc").initComboGrid({
//				title : '使用科室', //标题
//				classname : 'web.DHCEQ.Process.DHCEQFind', //类名
//				queryname : 'GetEQLoc',  //Query名
//				queryParams : ',,,0102,', //参数
//				curqueryParams : 2, //检索参数所在位置
//				obj : 'useloc', //点击对象
//              callBackFunction:function(){myFunction()} //选值后调用函数
//			});
// 关于ID获取:需要在界面增加'uselocdr'影藏元素,既combogrid名称后面加'dr',用户存放ID值
(function(jQuery){
	jQuery.fn.initComboGrid=function(options){
		var defaults = {
            	title: '',
                classname: '',
                queryname: '0',
                queryParams: '',
                curqueryParams: '',
                obj: '',
                callBackFunction: function(){return;}
            };
        var option = jQuery.extend(defaults, options || {});
	    jQuery("#"+option.obj).combogrid({
			panelWidth: 450,  //下拉框宽度
			border:false,
			rownumbers: true,  //如果为true，则显示一个行号列。
			idField: 'TRowID',
			textField: 'TName',
		    pagination:true,  //如果为true，则分页显示。
		    pageSize:10,
		    pageNumber:1,
		    pageList:[10,20,30],
			columns:[[
			    {field:'TName',title:option.title,width:350},
			    {field:'TRowID',title:'ID',hidden:true},
			    ]],
			onLoadSuccess:function(data) {},
			onLoadError:function() { jQuery.messager.messageShow("","","",option.title, "加载"+option.title+"列表失败!");},
			onChange:function(newValue, oldValue){jQuery("#"+option.obj+"dr").val("")},
			onSelect: function(rowIndex, rowData) {
					var curdr=jQuery("#"+option.obj).combogrid("getValue");
					jQuery("#"+option.obj+"dr").val(curdr);
					option.callBackFunction();
				},
			keyHandler:{
				query:function(q){
					var object1=new Object();
					object1=jQuery(this);
					//输入框监听搜索
					if (this.AutoSearchTimeOut) {
						window.clearTimeout(this.AutoSearchTimeOut);
						this.AutoSearchTimeOut=window.setTimeout(function(){ _initComboData(option.obj,option.classname,option.queryname,option.queryParams,option.curqueryParams);},400); 
					}else{
						this.AutoSearchTimeOut=window.setTimeout(function(){ _initComboData(option.obj,option.classname,option.queryname,option.queryParams,option.curqueryParams);},400); 
					}
					jQuery(this).combogrid("setValue",q);
				},
				enter:function(){_comboGridKeyEnter(option.obj);},
				up:function(){_comboGridKeyUp(option.obj);},
				down:function(){_comboGridKeyDown(option.obj);}
			}
		});
		//当前对象父级元素内光标聚焦事件
		jQuery("#"+option.obj).parent().focusin(function(){_initComboData(option.obj,option.classname,option.queryname,option.queryParams,option.curqueryParams);});
	}
	//ComboGridKeyUp事件函数
	_comboGridKeyUp=function(Obj)
	{
	    var pClosed = jQuery("#"+Obj).combogrid("panel").panel("options").closed;
	    if (pClosed) {jQuery("#"+Obj).combogrid("showPanel");}
	    var grid = jQuery("#"+Obj).combogrid("grid");
	    var rowSelected = grid.datagrid("getSelected");
	    if (rowSelected != null)
	    {
	        var rowIndex = grid.datagrid("getRowIndex", rowSelected);
	        if (rowIndex > 0)
	        {
	            rowIndex = rowIndex - 1;
	            grid.datagrid("selectRow", rowIndex);
	        }
	    }
	    else if (grid.datagrid("getRows").length > 0)
	    {
	        grid.datagrid("selectRow", 0);
	    }
	}
	//ComboGridKeyDown事件函数
	_comboGridKeyDown=function(Obj)
	{
	    var pClosed = jQuery("#"+Obj).combogrid("panel").panel("options").closed;
	    if (pClosed) {jQuery("#"+Obj).combogrid("showPanel");}
	    var grid = jQuery("#"+Obj).combogrid("grid");
	    var rowSelected = grid.datagrid("getSelected");
	    if (rowSelected != null)
	    {
	        var totalRow = grid.datagrid("getRows").length;
	        var rowIndex = grid.datagrid("getRowIndex", rowSelected);
	        if (rowIndex < totalRow - 1)
	        {
	            rowIndex = rowIndex + 1;
	            grid.datagrid("selectRow", rowIndex);
	        }
	    }
	    else if (grid.datagrid("getRows").length > 0)
	    {
	        grid.datagrid("selectRow", 0);
	    }
	}
	//ComboGridKeyEnter事件函数
	_comboGridKeyEnter=function(Obj)
	{
	    var grid = jQuery("#"+Obj).combogrid("grid");
	    var rowSelected = grid.datagrid("getSelected");
	    var SelectTxt=""
	    if (rowSelected!=null)
	    {
		    SelectTxt=rowSelected[grid.datagrid('options').textField]
	    }
		var ElementTxt = jQuery("#"+Obj).combogrid("getText");
		if ((rowSelected!=null)&&(SelectTxt==ElementTxt))
		{
			var pClosed = jQuery("#"+Obj).combogrid("panel").panel("options").closed;
			if (!pClosed){jQuery("#"+Obj).combogrid("hidePanel");}
		}
		else
		{
			
		}
	}
	/***加载ComboGrid数据*/
	_loadComboGridStore=function(Obj,queryParams)
	{
		var jQueryComboGridObj = jQuery("#"+Obj);
		var grid = jQueryComboGridObj.combogrid('grid');	// 获取数据表格对象
		var opts = grid.datagrid("options");
		opts.url = "./dhceq.jquery.grid.easyui.csp";
		grid.datagrid('load', queryParams);
	}
	//初始化Combogrid数据
	_initComboData=function(Obj,vClassName,vQueryName,vQueryParams,vCurQueryParams)
	{
		var queryParams = new Object();
		var ParamsInfo=vQueryParams.split(",")
		queryParams.ClassName = vClassName;
		queryParams.QueryName = vQueryName;
		//参数传递前重新获取输入框内文本信息
		ParamsInfo[vCurQueryParams-1]=jQuery("#"+Obj).combogrid("getText").toString();
		var len=ParamsInfo.length;
		for(var i=1 ; i<=len; i++)
		{
			if (i==1) {queryParams.Arg1 = ParamsInfo[0];}
			if (i==2) {queryParams.Arg2 = ParamsInfo[1];}
			if (i==3) {queryParams.Arg3 = ParamsInfo[2];}
			if (i==4) {queryParams.Arg4 = ParamsInfo[3];}
			if (i==5) {queryParams.Arg5 = ParamsInfo[4];}
			if (i==6) {queryParams.Arg6 = ParamsInfo[5];}
			if (i==7) {queryParams.Arg7 = ParamsInfo[6];}
			if (i==8) {queryParams.Arg8 = ParamsInfo[7];}
			if (i==9) {queryParams.Arg9 = ParamsInfo[8];}
			if (i==10) {queryParams.Arg10 = ParamsInfo[9];}
			if (i==11) {queryParams.Arg11 = ParamsInfo[10];}
			if (i==12) {queryParams.Arg12 = ParamsInfo[11];}
			if (i==13) {queryParams.Arg13 = ParamsInfo[12];}
			if (i==14) {queryParams.Arg14 = ParamsInfo[13];}
			if (i==15) {queryParams.Arg15 = ParamsInfo[14];}
			if (i==16) {queryParams.Arg16 = ParamsInfo[15];}
		}
		queryParams.ArgCnt = len;
		_loadComboGridStore(Obj, queryParams);
	}
})(jQuery);
