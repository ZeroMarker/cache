function dataLoaderOfGrp(params,successcb,errorcb){
    params.start=((params.page-1)*params.rows);
	params.limit=params.rows;
	$.ajax({
		url:'dhcwl/mrcfg/mrtjservice.csp?action=getMRICDCate',
		type: "POST",
		dataType:"text",
		data:params,
		success: function(data){
			var json=eval('(' + data + ')');
			json.total=json.totalNum;
			json.rows=json.root;
			successcb(json)

		},error:function (XMLHttpRequest, textStatus, errorThrown) {
			alert("error");
		}
	});
}
function dataLoaderOfDetail(params,successcb,errorcb){
    params.start=((params.page-1)*params.rows);
	params.limit=params.rows;
	$.ajax({
		url:'dhcwl/mrcfg/mrtjservice.csp?action=GetICDCateDetails&ICDCId='+params.ICDCId,
		type: "POST",
		dataType:"text",
		data:params,
		success: function(data){
			var json=eval('(' + data + ')');
			json.total=json.totalNum;
			json.rows=json.root;
			successcb(json)

		},error:function (XMLHttpRequest, textStatus, errorThrown) {
			alert("error");
		}
	});
}
var addParam={
	curAct:"",
	row:""
};
var showDetail=function(inx){
	var data=$('#rptmgmt-datashow').datagrid('getData');
	row=data.rows[inx];
	
	$("#MenuName").val(row.MenuName);
	$("#AuxiliaryMenuName").val(row.AuxiliaryMenuName);		
	$("#RaqName").val(row.RaqName);
	$("#CSPName").val(row.CSPName);
	$("#QueryName").val(row.QueryName);
	$("#Filter").val(row.Filter);
	$("#RowColShow").val(row.RowColShow);
	$("#CellSubgrpMap").val(row.CellSubgrpMap);
	$("#Spec").combobox("setValue",row.Spec);
	$("#HisTableName").combobox("setValue",row.HisTableName);
	$("#KPIName").val(row.KPIName);
	$("#ProgramLogic").val(row.ProgramLogic);
	$("#AdvUser").val(row.AdvUser);
	$("#ProMaintainer").val(row.ProMaintainer);
	$("#DepMaintainer").val(row.DepMaintainer);
	$("#UsedByDep").val(row.UsedByDep);		
	$("#CellSubgrpMap").val(row.CellSubgrpMap);	
	CKEDITOR.instances.idckeditor.setData(row.Demo); 
	
	addParam.curAct="browse";
	//addParam.row=row;
	//$('#rptmgmt-add .dialog-toolbar').eq(0).hide();
	$HUI.dialog("#rptmgmt-add",{
		title:'浏览',
		iconCls:'icon-w-update'}
	);			
	$('#rptmgmt-add').dialog('open');	

};


var showLink=function(inx){
	var data=$('#rptmgmt-datashow').datagrid('getData');
	row=data.rows[inx];
	/*
	var html=[];
	html.push('<h1 align="center">超链接文本</h1>');
	html.push('<hr>');
	html.push('生成的超链接文本');
	html.push('<hr>');
	
	html.push('<p style="font-size: 15px;text-indent:2em;">');
	html.push("\"javascript:cpm_showWindow('DTHealth-DHCWL-报表管理帮助.raq','inRaqName="+row.RaqName+"&inCSPName="+row.CSPName+"&inAuxiliaryMenuName="+row.AuxiliaryMenuName+"')\"");
	html.push('</p>');
	html.push('</br>');
	html.push('<p style="font-size: 14px;text-indent:2em;">可以将该文本复制到润乾文件中，作为超链接表达式的值</p>');
	
	html.join('');	
	*/

	
	$HUI.dialog("#rptmgmt-showLinkDlg",{
			iconCls:'icon-w-add',
			resizable:false,
			modal:true,
			position: ['center','center'],
			autoOpen: false,
			buttons:[{
				text:'关闭',
				handler:function(){
					$('#rptmgmt-showLinkDlg').dialog('close');
				}
			}]
	});	

	showLinkText="\"javascript:cpm_showWindow('DTHealth-DHCWL-报表管理帮助.raq','inRaqName="+row.RaqName+"&inCSPName="+row.CSPName+"&inAuxiliaryMenuName="+row.AuxiliaryMenuName+"')\"";
	$("#showLinkText").html(showLinkText);
	$('#rptmgmt-showLinkDlg').dialog('open');	
	
}


var init = function(){
	var outthis=this;
	////////////////////////////////////////////////////////
	///1、报表管理主页面
	///报表管理表格datagrid
	var rptmgmtGrid = $HUI.datagrid("#rptmgmt-datashow",{
		url:$URL,
		queryParams:{
			ClassName:"web.DHCWL.V1.RptMgmt",
			MethodName:"getSavedMgmt2",		//通过方法得到grid数据，不带返回值，数据直接在方法中输出	
			wantreturnval:0,
			searchValue:""
		},
		columns:[[
			{field:'action',title:'操作',width:70,align:'center',
				formatter:function(value,row,index){
						//var s = '<a href="javascript:void(0)" data-options="iconCls:\'icon-apply-check\'" style="text-decoration: underline " onclick="showDetail('+index+')"></a> ';
						//var s = '<span class="icon icon-apply-check"  onclick="showDetail('+index+')">&nbsp</span> ';
						var s = "<a href='#' title='明细' class='hisui-tooltip' ><span class='icon icon-apply-check'  onclick='showDetail("+index+")'>&nbsp;</span></a>&nbsp;&nbsp;<a href='#' title='链接文本' class='hisui-tooltip' ><span class='icon icon-paper-link'  onclick='showLink("+index+")'>&nbsp;</span></a>";

						
						return s;
				} 
			},
			{field:'MenuName',title:'菜单名称',width:100,align:'left'},
			{field:'RaqName',title:'raq名称',width:100,align:'left'},
			{field:'CSPName',title:'CSP名称',width:100,align:'left'},	
			{field:'AuxiliaryMenuName',title:'当前页面(标题)名称',width:120,align:'left'},
			{field:'AdvUser',title:'高级客户',width:70,align:'left'},
			{field:'ProMaintainer',title:'项目工程师',width:80,align:'left'},
			{field:'DepMaintainer',title:'开发工程师',width:80,align:'left'},
			{field:'CreateDate',title:'日期',width:70,align:'left',hidden:true},
			{field:'UPdateDate',title:'最后更新日期',width:100,align:'left'},
			{field:'UsedByDep',title:'使用(科室)部门',width:100,align:'left'},
			{field:'Demo',title:'备注',width:100,align:'left',hidden:true},	
			{title:'主程序query',field:'QueryName',align:'left',hidden:true},
			{title:'统计口径',field:'Spec',align:'left',hidden:true},
			{title:'业务表',field:'HisTableName',align:'left',hidden:true},
			{title:'指标',field:'KPIName',align:'left',hidden:true},
			{title:'数据条件',field:'Filter',align:'left',hidden:true},
			{title:'显示条件',field:'RowColShow',align:'left',hidden:true},
			{title:'逻辑说明',field:'ProgramLogic',align:'left',hidden:true},
			{title:'ID',field:'ID',align:'left',hidden:true},
			{title:'单元格-统计子组对应关系',field:'CellSubgrpMap',align:'left',hidden:true}



	    ]],
		pagination:true,
		pageSize:15,
	    pageList:[1,2,5,10,15,20,50,100],
		fit:true,
		fitColumns:true,
		//Select事件响应方法
		onSelect:function(rowIndex,rowData){

		}
	});
	

	
	
	
	
	///主界面查询响应方法
	//$('#searchdatashowText').searchbox({
	$('#searchBtn').searchbox({	
		searcher:function(value){
			rptmgmtGrid.load({ClassName:"web.DHCWL.V1.RptMgmt",MethodName:"getSavedMgmt2",wantreturnval:0,searchValue:value});
		}
	});
	
	
	///主界面事件处理
	$('#rptmgmt-datashow').datagrid({
		onSelect:function() {
			$('#btnmainmodify').linkbutton("enable");
		}
	});
	///新增响应方法
	$("#btnmainadd").click(function (argument) {
		
		$("#MenuName").val("");
		$("#AuxiliaryMenuName").val("");	
		$("#RaqName").val("");
		$("#CSPName").val("");
		$("#QueryName").val("");
		$("#Filter").val("");
		$("#RowColShow").val("");
		$("#CellSubgrpMap").val("");
		$("#Spec").combobox("setValue","");
		$("#HisTableName").combobox("setValue","");
		$("#KPIName").val("");
		$("#ProgramLogic").val("");
		$("#AdvUser").val("");
		$("#ProMaintainer").val("");
		$("#DepMaintainer").val("");
		$("#UsedByDep").val("");	
		CKEDITOR.instances.idckeditor.setData(""); 
		
		addParam.curAct="add";	
		//$('#rptmgmt-add .dialog-toolbar').eq(0).show();
		$HUI.dialog("#rptmgmt-add",{
			title:'新增',
			iconCls:'icon-w-add',
			resizable:false,
			modal:true,
			position: ['center','center']			
			
		});

					
		$('#rptmgmt-add').dialog('open');
	});	
	

	///修改响应方法
	$("#btnmainmodify").click(function (argument) {
		var row =rptmgmtGrid.getSelected();
		if (!row) {
			$.messager.alert("提示","请选择需要修改的数据！");
			return;
		}
		$("#MenuName").val(row.MenuName);
		$("#AuxiliaryMenuName").val(row.AuxiliaryMenuName);		
		$("#RaqName").val(row.RaqName);
		$("#CSPName").val(row.CSPName);
		$("#QueryName").val(row.QueryName);
		$("#Filter").val(row.Filter);
		$("#RowColShow").val(row.RowColShow);
		$("#CellSubgrpMap").val(row.CellSubgrpMap);
		$("#Spec").val(row.Spec);
		$("#HisTableName").val(row.HisTableName);
		$("#KPIName").val(row.KPIName);
		$("#ProgramLogic").val(row.ProgramLogic);
		$("#AdvUser").val(row.AdvUser);
		$("#ProMaintainer").val(row.ProMaintainer);
		$("#DepMaintainer").val(row.DepMaintainer);
		$("#UsedByDep").val(row.UsedByDep);		
		$("#CellSubgrpMap").val(row.CellSubgrpMap);	
		CKEDITOR.instances.idckeditor.setData(row.Demo); 
		
		addParam.curAct="modify";
		addParam.row=row;
		//$('#rptmgmt-add .dialog-toolbar').eq(0).hide();
		$HUI.dialog("#rptmgmt-add",{
			iconCls:'icon-w-edit',
			title:'修改'});			
		$('#rptmgmt-add').dialog('open');
		
		
		
	});


	//var ccObj=$HUI.combo('#CSPName',{});

	///////////////////////////////////////////////////////////
	///新增对话框页面
	///新增对话框
	var rptAddDlgObj = $HUI.dialog("#rptmgmt-add",{
		iconCls:'icon-w-add',
		resizable:false,
		modal:true,
		position: ['center','center'],
		autoOpen: false,
		///open方法重写,初始化ckeditor
		open: function () {
			$(this).find('textarea').ckeditor();
		},
		///close方法重写,关闭对话框时销毁ckeditor
		close: function () {
			$(this).find('textarea').each(function(){
				$(this).ckeditorGet().destroy();
			});
		},			
		toolbar:[{
			iconCls:'icon-add-diag',
			text:'引入HIS菜单数据',
			//disabled:true,
			id:'btnLoadHisMenuData',
			handler:function(){
				$('#rptmgmt-add-importHISDataDlg').dialog('open');
				setFieldValue("importHisDataTB","MenuName", "");
				setFieldValue("importHisDataTB","RaqName", "");
				setFieldValue("importHisDataTB","CSPName", "");
				importHISGrid.load({ClassName:"web.DHCWL.V1.RptMgmt",MethodName:"GetMenuCfg",wantreturnval:0,MenuName:"",RaqName:"raq",CSPName:""});
				
			}
			
		},{
			iconCls:'icon-add-note',
			text:'引入其他说明数据',
			//disabled:true,
			id:'btnLoadOtherMgmtData',
			handler:function(){
				
				setFieldValue("importOtherDataTB","MenuName","");			
				setFieldValue("importOtherDataTB","RaqName","");
				setFieldValue("importOtherDataTB","CSPName","");				
				
				importOtherObj.open();
				importOtherObj.callBack=importOtherData;		
				importOtherGrid.load();
			}
		}],			
			
		buttons:[{
			id:'btnRptmgmtaddSave',
			text:'保存',
			handler:OnSave
		},{
			id:'btnRptmgmtaddClose',
			text:'关闭',
			handler:function(){
				$('#rptmgmt-add').dialog('close');
			}
		},{
			id:'btnRptmgmtaddConfirm',
			text:'确定',
			handler:function(){
				$('#rptmgmt-add').dialog('close');
			}			
		}],
		onOpen:function(){
			if(addParam.curAct=="modify") {
				$("div#rptmgmt-add input").removeAttr("disabled");
				$("div#rptmgmt-add select").removeAttr("disabled");			
				$('#btnRptmgmtaddSave').show();
				$('#btnRptmgmtaddClose').show();
				$('#btnRptmgmtaddConfirm').hide();
				CKEDITOR.instances.idckeditor.setReadOnly(false);				
				
				
				$('#rptmgmt-add .dialog-toolbar').eq(0).hide();	
			}else if (addParam.curAct=="browse"){
				$("div#rptmgmt-add input").attr("disabled","true");
				$("div#rptmgmt-add select").attr("disabled","true");		
				$('#rptmgmt-add .dialog-toolbar').eq(0).hide();	
				$('#btnRptmgmtaddSave').hide();
				$('#btnRptmgmtaddClose').hide();
				$('#btnRptmgmtaddConfirm').show();
				CKEDITOR.instances.idckeditor.setReadOnly(true);
						
			}else if (addParam.curAct=="add") {
				$('#rptmgmt-add .dialog-toolbar').eq(0).show();	
				$("div#rptmgmt-add input").removeAttr("disabled");
				$("div#rptmgmt-add select").removeAttr("disabled");			
				$('#btnRptmgmtaddSave').show();
				$('#btnRptmgmtaddClose').show();
				$('#btnRptmgmtaddConfirm').hide();
				CKEDITOR.instances.idckeditor.setReadOnly(false);				
			}
		}
	});	
	
	

		
	///新增-保存响应方法
	function OnSave() {
		var ID="";
		var action="addRec";
		if (addParam.curAct=="modify") {
			action="updateRec";
			ID=addParam.row.ID;
		}
		
		var MenuName=$("#MenuName").val();
		var AuxiliaryMenuName=$("#AuxiliaryMenuName").val();
		var RaqName=$("#RaqName").val();
		var CSPName=$("#CSPName").val();
		var QueryName=$("#QueryName").val();
		var Filter=$("#Filter").val();
		var RowColShow=$("#RowColShow").val();
		var CellSubgrpMap=$("#CellSubgrpMap").val();
		var Spec=$("#Spec").combobox("getValue");
		var HisTableName=$("#HisTableName").combobox("getValue");
		var KPIName=$("#KPIName").val();
		var ProgramLogic=$("#ProgramLogic").val();
		var AdvUser=$("#AdvUser").val();
		var ProMaintainer=$("#ProMaintainer").val();
		var DepMaintainer=$("#DepMaintainer").val();
		var UsedByDep=$("#UsedByDep").val();
		var CellSubgrpMap=$("#CellSubgrpMap").val();
		var Demo=CKEDITOR.instances.idckeditor.getData(); 

		var beTestedV=""+MenuName+AuxiliaryMenuName+RaqName+CSPName+QueryName+Filter+RowColShow+CellSubgrpMap+Spec+HisTableName+KPIName+ProgramLogic+AdvUser+ProMaintainer+DepMaintainer+UsedByDep+CellSubgrpMap;
		var pattern=/[$%|\"\']/;
		if(pattern.test(beTestedV)) 
		{
			$.messager.alert("提示","填写的数据不能包含特殊字符:$,%,|,\",\'");
			return ;
		}
		if(pattern.test(MenuName)) 
		{
			$.messager.alert("提示","名称只能由 '字母'、'数字'、'-'或'_' 组成!");
			return ;
		}			
		if (MenuName=="") {
			$.messager.alert("提示","菜单名称不能为空");
			return;
		}
		if (QueryName=="") {
			$.messager.alert("提示","query名称不能为空");
			return;
		}
		if (RaqName=="" && CSPName=="") {
			$.messager.alert("提示","raq名称或csp名称不能同时为空");
			return;
		}	
		if (RaqName!="") {
			if (CSPName=="") {
				$.messager.alert("提示","csp名称不能为空");
				return;
			}				
			if (Filter=="") {
				$.messager.alert("提示","数据条件不能为空");
				return;
			}		
			if (RowColShow=="") {
				$.messager.alert("提示","显示条件不能为空");
				return;
			}	
			if (Spec=="") {
				$.messager.alert("提示","统计口径不能为空");
				return;
			}
			if (HisTableName=="" && KPIName=="") {
				$.messager.alert("提示","业务表名称或指标名称不能同时为空");
				return;
			}	

			if (ProgramLogic=="") {
				$.messager.alert("提示","逻辑说明不能为空");
				return;
			}	
		}
		if (AdvUser=="") {
			$.messager.alert("提示","高级客户不能为空");
			return;
		}
		if (ProMaintainer=="") {
			$.messager.alert("提示","项目工程师不能为空");
			return;
		}	
		if (DepMaintainer=="") {
			$.messager.alert("提示","开发工程师不能为空");
			return;
		}	
		if (UsedByDep=="") {
			$.messager.alert("提示","使用（科室）部门不能为空");
			return;
		}			
		if (AuxiliaryMenuName=="") {
			$.messager.alert("提示","当前页面(标题)名称不能为空");
			return;
		}		
		var data = $.cm({ClassName:"web.DHCWL.V1.RptMgmt",MethodName:"AddMgmtRec","ID":ID,"MenuName":MenuName,"RaqName":RaqName,"CSPName":CSPName,"QueryName":QueryName,"AuxiliaryMenuName":AuxiliaryMenuName,"Spec":Spec,"HisTableName":HisTableName,"KPIName":KPIName,"Filter":Filter,"RowColShow":RowColShow,"ProgramLogic":ProgramLogic,"AdvUser":AdvUser,"ProMaintainer":ProMaintainer,"DepMaintainer":DepMaintainer,"Demo":Demo,"UsedByDep":UsedByDep,"CellSubgrpMap":CellSubgrpMap
			},false,function(data){
				if("ok"==data.responseText){
					//detailAddDlgObj.close();
					rptmgmtGrid.load();
					$('#rptmgmt-add').dialog('close');
					
				}else{
					$.messager.alert("提示",data.responseText);
				}
			});	
	}	
	

	
	
	///////////////////////////////////////////////////////////////////////////////////////////////
	/////////////引入HIS菜单数据
	//引入HIS菜单数据界面grid
	var importHISGrid = $HUI.datagrid("#rptmgmt-add-importHISDataGrid",{
		url:$URL,
		queryParams:{
			ClassName:"web.DHCWL.V1.RptMgmt",
			MethodName:"GetMenuCfg",		//通过方法得到grid数据，不带返回值，数据直接在方法中输出	
			wantreturnval:0,
			MenuName:"",
			RaqName:"raq",
			CSPName:""
		},
		columns:[[
			{field:'MenuName',title:'菜单名称',width:100,align:'left'},
			{field:'RaqName',title:'菜单表达式',width:100,align:'left'},
			{field:'CSPName',title:'CSP名称',width:100,align:'left'}			
	    ]],
		pagination:true,
		pageSize:15,
	    pageList:[5,10,15,20,50,100],
		fit:true,
		fitColumns:true,
		//Select事件响应方法
		onDblClickRow:function(rowIndex,rowData){
			importHisData();
			$('#rptmgmt-add-importHISDataDlg').dialog('close');
		}
	});	
	//导入HIS菜单数据-双击响应方法
	function importHisData() {
		var rowData=importHISGrid.getSelected();
		if (!!rowData)
		{
			$("#MenuName").val(rowData.MenuName);
			$("#RaqName").val(rowData.RaqName);
			$("#CSPName").val(rowData.CSPName);
			$("#AuxiliaryMenuName").val(rowData.CSPName);
		}	
	}
	//引入HIS菜单数据界面dialog
	var importHISObj = $HUI.dialog("#rptmgmt-add-importHISDataDlg",{
		iconCls:'icon-w-paper',
		resizable:false,
		modal:true,
		position: ['center','center'],
		autoOpen: false
		,buttons:[{
			text:'确定',
			handler:function(){
				importHisData();
				$('#rptmgmt-add-importHISDataDlg').dialog('close');	
			}
		},{
			text:'取消',
			handler:function(){
				$('#rptmgmt-add-importHISDataDlg').dialog('close');	
			}
		}]
		
	});	
	
	//引入HIS菜单数据-查询 响应方法
	$(function(){
		$('#searchHIsMenuText').bind('click', function(){
			var MenuName=getFieldValue("importHisDataTB","MenuName");
			var RaqName=getFieldValue("importHisDataTB","RaqName");
			var CSPName=getFieldValue("importHisDataTB","CSPName");
			importHISGrid.load({ClassName:"web.DHCWL.V1.RptMgmt",MethodName:"GetMenuCfg",wantreturnval:0,MenuName:MenuName,RaqName:RaqName,CSPName:CSPName});
			
		});
	});

	///////////////////////////////////////////////////////////////////////////////////////////////
	/////////////引入其他说明数据
	///引入HIS菜单数据界面grid
	var importOtherGrid = $HUI.datagrid("#rptmgmt-add-importOtherDataGrid",{
		url:$URL,
		queryParams:{
			ClassName:"web.DHCWL.V1.RptMgmt",
			MethodName:"getSavedMgmt",		//通过方法得到grid数据，不带返回值，数据直接在方法中输出	
			wantreturnval:0,
			MenuName:"",
			RaqName:"",
			CSPName:""
		},
		columns:[[
			{field:'MenuName',title:'菜单名称',width:100,align:'left'},
			{field:'AuxiliaryMenuName',title:'当前页面(标题)名称',width:100,align:'left'},
			{field:'RaqName',title:'raq名称',width:100,align:'left'},
			{field:'CSPName',title:'CSP名称',width:100,align:'left'},
			{field:'AdvUser',title:'高级客户',width:100,align:'left',hidden:true},
			{field:'Demo',title:'其他备注',width:100,align:'left',hidden:true},
			{field:'DepMaintainer',title:'开发工程师',width:100,align:'left',hidden:true},
			{field:'Filter',title:'数据条件',width:100,align:'left',hidden:true},
			{field:'HisTableName',title:'业务表',width:100,align:'left',hidden:true},
			{field:'KPIName',title:'指标',width:100,align:'left',hidden:true},
			{field:'ProMaintainer',title:'项目工程师',width:100,align:'left',hidden:true},
			{field:'ProgramLogic',title:'逻辑说明',width:100,align:'left',hidden:true},
			{field:'QueryName',title:'Query名称',width:100,align:'left',hidden:true},
			{field:'RowColShow',title:'显示条件',width:100,align:'left',hidden:true},
			{field:'Spec',title:'统计口径',width:100,align:'left',hidden:true},
			{field:'UsedByDep',title:'使用（科室）部门',width:100,align:'left',hidden:true},
			{field:'CellSubgrpMap',title:'单元格-统计子组对应关系',width:100,align:'left',hidden:true}
	    ]],
		pagination:true,
		pageSize:15,
	    pageList:[5,10,15,20,50,100],
		fit:true,
		fitColumns:true,
		//Select事件响应方法
		onDblClickRow:function(rowIndex,rowData){
			if (!!importOtherObj.callBack) {
				var rowData=importOtherGrid.getSelected();
				importOtherObj.callBack(rowData);
			};
			$('#rptmgmt-add-importOtherDataDlg').dialog('close');
		}
	});	
	//导入HIS菜单数据-双击响应方法
	function importOtherData(rowData) {
		if (!!rowData)
		{
			$("#MenuName").val(rowData.MenuName);
			$("#RaqName").val(rowData.RaqName);
			$("#CSPName").val(rowData.CSPName);
			$("#AuxiliaryMenuName").val(rowData.AuxiliaryMenuName);
			$("#AdvUser").val(rowData.AdvUser);
			$("#DepMaintainer").val(rowData.DepMaintainer);
			$("#Filter").val(rowData.Filter);	
			$("#HisTableName").combobox("setValue",rowData.HisTableName);		
			$("#KPIName").val(rowData.KPIName);
			$("#ProMaintainer").val(rowData.ProMaintainer);
			$("#ProgramLogic").val(rowData.ProgramLogic);
			$("#QueryName").val(rowData.QueryName);
			$("#RowColShow").val(rowData.RowColShow);
			$("#Spec").combobox("setValue",rowData.Spec);
			
			$("#UsedByDep").val(rowData.UsedByDep);
			$("#CellSubgrpMap").val(rowData.CellSubgrpMap);
			CKEDITOR.instances.idckeditor.setData(rowData.Demo); 
		}	
	}
	//引入其他数据界面dialog
	var importOtherObj = $HUI.dialog("#rptmgmt-add-importOtherDataDlg",{
		iconCls:'icon-w-paper',
		resizable:false,
		modal:true,
		position: ['center','center'],
		autoOpen: false
		,buttons:[{
			text:'确定',
			handler:function(){
				if (!!importOtherObj.callBack) {
					var rowData=importOtherGrid.getSelected();
					importOtherObj.callBack(rowData);
				};
				$('#rptmgmt-add-importOtherDataDlg').dialog('close');	
			}
		},{
			text:'取消',
			handler:function(){
				$('#rptmgmt-add-importOtherDataDlg').dialog('close');	
			}
		}]
		
	});	
	
	//引入引入其他说明数据-查询 响应方法	
	$(function(){    
		$('#searchOtherDataText').bind('click', function(){
			var MenuName=getFieldValue("importOtherDataTB","MenuName");
			var RaqName=getFieldValue("importOtherDataTB","RaqName");
			var CSPName=getFieldValue("importOtherDataTB","CSPName");
			importOtherGrid.load({ClassName:"web.DHCWL.V1.RptMgmt",MethodName:"getSavedMgmt",wantreturnval:0,MenuName:MenuName,RaqName:RaqName,CSPName:CSPName});
			
		});
	});	
		
	///////////////////////////////////////////////////////////////////////////////////////////////
	/////////////比对
	//比对dialog
	var compareObj = $HUI.dialog("#rptmgmt-compareDlg",{
		iconCls:'icon-w-list',
		resizable:false,
		modal:true,
		position: ['center','center'],
		autoOpen: false,
		buttons:[{
			text:'确定',
			handler:function(){
				$('#rptmgmt-compareDlg').dialog('close');	
			}
		}],	
		toolbar:[{
			iconCls:'icon-add-note',
			text:'载入说明1',
			plain:"false",
			handler:function(){	
			
				setFieldValue("importOtherDataTB","MenuName","");			
				setFieldValue("importOtherDataTB","RaqName","");
				setFieldValue("importOtherDataTB","CSPName","");			
				importOtherObj.open();
				importOtherObj.callBack=loadCfgToFirst;
			}
		},{
			iconCls:'icon-add-note',
			text:'载入说明2',
			handler:function(){
				
				setFieldValue("importOtherDataTB","MenuName","");			
				setFieldValue("importOtherDataTB","RaqName","");
				setFieldValue("importOtherDataTB","CSPName","");				
				importOtherObj.open();
				importOtherObj.callBack=loadCfgToSec;
			}
		}]		
	});	
	
	//给form各自带赋值
	function loadRecord2(formID,rowData) {
		var x;
		for(x in rowData) {
			setFieldValue(formID,x,rowData[x]);
		}		
	}
	
	function clearForm(formID) {
		var selector="div#"+formID+" input";
		$(selector).each(function(){
			if (!$(this).attr("name")) return;
			//alert($(this).attr("name")+":"+$(this).val());
			$(this).val("");
		});		
		
	}	
	
	
	///比对按钮响应方法
	$("#btncompare").click(function (argument) {
		
		//如果在主页面中选中了记录，就把这个记录加载到“比对1”中。
		var row =rptmgmtGrid.getSelected();
		if (!!row) {
			loadRecord2("compare-firstCol",row);
			CKEDITOR.instances.idckeditor1.setData(row.Demo); 		
		}else{
			clearForm("compare-firstCol");
			CKEDITOR.instances.idckeditor1.setData(""); 
		}
		
		
		
		//清空“比对2”的数据		
		clearForm("compare-secCol");
		CKEDITOR.instances.idckeditor2.setData(""); 
		
		showDiff();
						
		$('#rptmgmt-compareDlg').dialog('open');
	});	
	
	//给form各自带赋值
	function loadRecord(formID,rowData) {
		var aryFields=["MenuName","AuxiliaryMenuName","RaqName","CSPName","AdvUser","Demo","DepMaintainer","Filter","HisTableName","KPIName","ProMaintainer","ProgramLogic","QueryName","RowColShow","Spec","UsedByDep","CellSubgrpMap"];
		var x;
		for(x in aryFields) {
			setFieldValue(formID,aryFields[x],rowData[aryFields[x]]);
		}		
	}
	//加载配置1数据
	function loadCfgToFirst(rowData) {
		var formID="compare-firstCol";
		loadRecord(formID,rowData);
		CKEDITOR.instances.idckeditor1.setData(rowData.Demo); 
		showDiff();
	}
	//加载配置2数据
	function loadCfgToSec(rowData) {
		var formID="compare-secCol";
		loadRecord(formID,rowData);
		CKEDITOR.instances.idckeditor2.setData(rowData.Demo);
		showDiff();
	}
	//2个配置不同时，显示红色边框	
	function showDiff() {
		var aryFields=["MenuName","AuxiliaryMenuName","RaqName","CSPName","AdvUser","Demo","DepMaintainer","Filter","HisTableName","KPIName","ProMaintainer","ProgramLogic","QueryName","RowColShow","Spec","UsedByDep","CellSubgrpMap"];
		var formID1="compare-firstCol";
		var formID2="compare-secCol";
		var x;
		
		for(x in aryFields) {
			if (getFieldValue(formID1,aryFields[x])!=getFieldValue(formID2,aryFields[x])) {
				addCls4Field(formID2,aryFields[x],"borderred");
			}else{
				removeCls4Field(formID2,aryFields[x],"borderred");
			}
		}
		/*
		if (CKEDITOR.instances.idckeditor1.getData()!=CKEDITOR.instances.idckeditor2.getData()) {
			addCls4Field("cke_idckeditor2","idckeditor2","borderred");
			$("#cke_idckeditor2").addClass("borderred");
		}else{
			$("#cke_idckeditor2").removeClass("borderred");
			
		}	*/	
	
	}
	//通用方法：得到表单对象
	function getField(formID,fieldName){
		$("div#"+formID+" [name='"+fieldName+"']");
	};
	//通用方法：得到表单值
	function getFieldValue(formID,fieldName) {
		return $("div#"+formID+" [name='"+fieldName+"']").val();
	};
	//通用方法：设置表单值
	function setFieldValue(formID,fieldName,value) {
		$("div#"+formID+" [name='"+fieldName+"']").val(value);		
	};
	//通用方法：增加表单样式
	function addCls4Field(formID,fieldName,clsName) {
		$("div#"+formID+" [name='"+fieldName+"']").addClass(clsName);
	};
	//通用方法：移走表单样式
	function removeCls4Field(formID,fieldName,clsName) {
		$("div#"+formID+" [name='"+fieldName+"']").removeClass(clsName);
	};
	

	//////////////////////////////////////////////////////////////////////////
	/////////导出
	////导出对话框
	var expDataObj = $HUI.dialog("#rptmgmt-expDataDlg",{
		iconCls:'icon-w-export',
		resizable:false,
		modal:true,
		position: ['center','center'],
		autoOpen: false
		,buttons:[{
			id:"btnExpData",
			text:'导出',
			handler:function(){
				var aryRecID=new Array();
				var selExpList=$('#rptmgmt-expDataGrid').datagrid('getSelections');	
				
				if (selExpList.length==0) {
					$.messager.alert("提示","请选择需要导出的数据");
					return;
				}			
				
				
				for(var j=0;j<=selExpList.length-1;j++) {
					aryRecID.push(selExpList[j].ID);
				}		
				var expIDs=aryRecID.join();
			
				var rtn = $.cm({
					ResultSetType:"Excel",
					ExcelName:"excelname", //默认DHCCExcel
					ClassName:"web.DHCWL.V1.RptMgmt",
					QueryName:"QryExpExcel",
					ExpIDs:expIDs
					},false,
				
				function(json){
						parent.location.href = json.responseText
						//	"dhctt.file.csp?act=download&filename=excelname.csv&dirname=D:\\DtHealth\\app\\dthis\\web\\temp\\excel\\"
						}
						
							
						);
				$('#rptmgmt-expDataDlg').dialog('close');	
			}
		},{
			text:'取消',
			handler:function(){
				$('#rptmgmt-expDataDlg').dialog('close');	
			}
		}]
		
	});		
	///导出datagrid
	var expGrid = $HUI.datagrid("#rptmgmt-expDataGrid",{
		url:$URL,
		queryParams:{
			ClassName:"web.DHCWL.V1.RptMgmt",
			MethodName:"getSavedMgmt",		//通过方法得到grid数据，不带返回值，数据直接在方法中输出	
			wantreturnval:0,
			MenuName:"",
			RaqName:"",
			CSPName:""
		},
		columns:[[
			{field:'ck',checkbox:'true'},
			{field:'MenuName',title:'菜单名称',width:100,align:'left'},
			{field:'AuxiliaryMenuName',title:'当前页面(标题)名称',width:100,align:'left'},
			{field:'RaqName',title:'raq名称',width:100,align:'left'},
			{field:'CSPName',title:'CSP名称',width:100,align:'left'},
			{field:'ID',title:'ID',width:100,hidden:true}
			
	    ]],
		fit:true,
		fitColumns:true
	});	

	///主页面导出按钮响应方法
	$("#btnexport").click(function () {	
		expGrid.load({ClassName:"web.DHCWL.V1.RptMgmt",MethodName:"getSavedMgmt",wantreturnval:0,MenuName:"",RaqName:"",CSPName:"",page:1,rows:0});
		//$('#btnExpData').linkbutton("disable");	
						
		setFieldValue("expDataTB","MenuName","");			
		setFieldValue("expDataTB","RaqName","");
		setFieldValue("expDataTB","CSPName","");
						
		$('#rptmgmt-expDataDlg').dialog('open');
	});	
	///导出datagrid事件响应方法
	/*
	$('#rptmgmt-expDataGrid').datagrid({
		onCheck:function(){
			var selRecs=$('#rptmgmt-expDataGrid').datagrid('getSelections');
			$('#btnExpData').linkbutton("enable");
		},
		onUncheck:function(){
			var selRecs=$('#rptmgmt-expDataGrid').datagrid('getSelections');
			if (selRecs.length==0) $('#btnExpData').linkbutton("disable");
		},
		onCheckAll:function(){
			
			
			var selRecs=$('#rptmgmt-expDataGrid').datagrid('getSelections');
			if (selRecs.length==0) $('#btnExpData').linkbutton("disable");
			else $('#btnExpData').linkbutton("enable");
			
		},
		onUncheckAll:function(){
			var selRecs=$('#rptmgmt-expDataGrid').datagrid('getSelections');
			if (selRecs.length==0) $('#btnExpData').linkbutton("disable");
		}
	});	*/
	
	//导出页面查询-响应方法
	$(function(){    
		$('#expDataSearchText').bind('click', function(){
			var MenuName=getFieldValue("expDataTB","MenuName");
			var RaqName=getFieldValue("expDataTB","RaqName");
			var CSPName=getFieldValue("expDataTB","CSPName");
			expGrid.load({ClassName:"web.DHCWL.V1.RptMgmt",MethodName:"getSavedMgmt",wantreturnval:0,MenuName:MenuName,RaqName:RaqName,CSPName:CSPName,page:1,rows:0});
			
		});
	});		

	
	//////////////////////////////////////////////////////////////////////////
	/////////导入
	////导入对话框
	var impExlDataObj=new Array();
	var ImpFieldNames=["MenuName","RaqName","CSPName","QueryName","Spec","HisTableName","KPIName","Filter","RowColShow","ProgramLogic","AdvUser","ProMaintainer","DepMaintainer","Demo","CreateDate","UPdateDate","AuxiliaryMenuName","UsedByDep","RaqCSPName","CellSubgrpMap"];
	var impDataObj = $HUI.dialog("#rptmgmt-impDataDlg",{
		iconCls:'icon-w-imp',
		resizable:false,
		modal:true,
		position: ['center','center'],
		autoOpen: false,
		onClose:function(){
			$("#txtImpFileName").val("");
		}
		,buttons:[{
			id:"btnImpData",
			text:'导入',
			handler:impDataFromFile
		},{
			text:'取消',
			handler:function(){
				$('#rptmgmt-impDataDlg').dialog('close');	
			}
		}]
		
	});	
	///导入grid
	var impGrid = $HUI.datagrid("#rptmgmt-impDataGrid",{
		columns:[[
			{field:'ck',checkbox:'true'},
			{field:'MenuName',title:'菜单名称',width:100,align:'left'},
			{field:'AuxiliaryMenuName',title:'当前页面(标题)名称',width:100,align:'left'},
			{field:'RaqName',title:'raq名称',width:100,align:'left'},
			{field:'CSPName',title:'CSP名称',width:100,align:'left'},
			{field:'IsExist',title:'CSP名称',width:100,align:'left',hidden:true},
			
	    ]],
		fit:true,
		fitColumns:true,
		rowStyler: function(index,row){
			if (row.IsExist==1){
				return 'background-color:#ffe3e3;color:#ff3d2c;'; // return inline style
			}
		}
	});	
	///导入grid事件响应方法
	/*
	$('#rptmgmt-impDataGrid').datagrid({
		onLoadSuccess: function(data){
			if (data.total>0) {
				CheckSameRecs(data);	
			}
		},
		onCheck:function(){
			$('#btnImpData').linkbutton("enable");
		},
		onUncheck:function(){
			var selRecs=$('#rptmgmt-impDataGrid').datagrid('getSelections');
			if (selRecs.length==0) $('#btnImpData').linkbutton("disable");
		},
		onCheckAll:function(){
			var selRecs=$('#rptmgmt-impDataGrid').datagrid('getSelections');
			if (selRecs.length==0) $('#btnImpData').linkbutton("disable");
			else $('#btnImpData').linkbutton("enable");
		},
		onUncheckAll:function(){
			var selRecs=$('#rptmgmt-impDataGrid').datagrid('getSelections');
			if (selRecs.length==0) $('#btnImpData').linkbutton("disable");
		}
	});
	*/
	///如果导入的记录在后台表中不存在，就自动勾选。
	function CheckSameRecs(data) {
		var inputList=data.rows;

		for(var i=inputList.length-1;i>=0;i-- ){
			rd=inputList[i];
			if (rd.IsExist==0) {
				$('#rptmgmt-impDataGrid').datagrid('selectRow',i);
			}
		}		
	}
	///导入响应方法
	$("#btnimport").click(function (argument) {	
		//清空数据
		setFieldValue("impDataTB","impFileName","");
		$('#rptmgmt-impDataGrid').datagrid('loadData', { total: 0, rows: [] });	
		//$('#btnImpData').linkbutton("disable");	
		
		$('#rptmgmt-impDataDlg').dialog('open');
	});
	
	///点击选择文件后加载文件内容到grid
	$("#impFileName").filebox({
		onChange: function(newVal,oldVal){
			outthis;
			if (newVal=="") return;
			if (newVal==oldVal) return;
			readImpDataFromFile(getFieldValue("impDataTB","impFileName"));
			loadImpGridData();
		}
	});
	
	
	$('#btnImpFileName').bind('click', function(){
		var fileName=$("#txtImpFileName").val();
		if (fileName=="") {
			$.messager.alert("提示","请输入文件路径！");
			return;
		}
		if (false) readImpDataFromFile(fileName);
		else readImpDataFromFileChrome(fileName);
		loadImpGridData();
	});	
	
	function readImpDataFromFileChrome(fileName){
		aryFieldName.length=0;
		impExlDataObj.length=0;
		var recDelive=String.fromCharCode('30');
		var fieldDelive=String.fromCharCode('31');
		var str = "(function test(x){"+
		"var rtn='';"+
		"var recDelive=String.fromCharCode('30');"+
		"var fieldDelive=String.fromCharCode('31');"+
		"var aryFieldNameChrome=new Array();"+
		"var impExlDataObjChrome=new Array();"+
		"var msg='';"+
		"var xlApp = new ActiveXObject('Excel.Application');"+
        "var xlBook = xlApp.Workbooks.Open('"+fileName+"');"+
		"var oSheet = xlBook.ActiveSheet;			"+
		"var rows =oSheet.usedrange.rows.count+1; "+
		"var colCnt =oSheet.usedrange.Columns.Count;"+
		"var fieldNameRowBegin=2;"+
		"var dataRowBegin=4;"+
		"var isValidFile=0;"+
		"for (var colInx = 1; colInx <= colCnt; colInx++) {"+
		"	var fieldName=oSheet.Cells(fieldNameRowBegin,colInx).value;"+
		"	aryFieldNameChrome.push(fieldName);"+
		"	if (fieldName=='MenuName') isValidFile=1;"+
		"}"+
		"if (isValidFile==0) {	"+
		"	oWB.Close();  "+
		"	oXL.Application.Quit();  "+
		"	CollectGarbage();"+
		"	msg='请确认是否是正确的导入文件！';			"+
		"}else{"+
		"   impExlDataObjChrome.push(aryFieldNameChrome.join(fieldDelive));"+
		"	for (var i = dataRowBegin; i <= rows; i++) {"+
		"		var rec=[];"+
		"		for (var j=1;j<=colCnt;j++) {"+
		"			var cellData=oSheet.Cells(i, j).value;"+
		"			if (cellData==undefined) cellData='';"+
		"			if (oSheet.Cells(i, j).NumberFormatLocal=='yyyy/m/d' || oSheet.Cells(i, j).NumberFormatLocal=='yyyy-m-d') {	"+				
		"				var d = new Date(cellData);"+
		"				cellData=d.getFullYear() + '-' + (d.getMonth() + 1) + '-' + d.getDate() ;"+					
		"			}"+
		"			rec.push(cellData);"+	
		"		}"+
		"		impExlDataObjChrome.push(rec.join(fieldDelive));	"+
		"	} "+
		"}"+
		"rtn=impExlDataObjChrome.join(recDelive);"+
		"return rtn;}());";		
		CmdShell.notReturn = 0;    //有返回值调用
		var rtn = CmdShell.EvalJs(str);     //运行代码且得到返回值		
				
		var aryDataObj=rtn.rtn.split(recDelive);
		if(aryDataObj.length>1)
			aryFieldName=aryDataObj[0].split(fieldDelive);
			
			
			for(var i=1;i<aryDataObj.length;i++){
				var rec={};
				var aryFv=aryDataObj[i].split(fieldDelive);
				for(var x in aryFieldName){
					
					rec[aryFieldName[x]]=aryFv[x];	
				}
				impExlDataObj.push(rec);	
			}
		
	}
		
	///把CSV数据加载到grid中
	function loadImpGridData() {
		var inputList=new Array();
		var gridData=new Array();
		for(var i=0;i<=impExlDataObj.length-1;i++) {
			var aryRec=[];
			var MenuName=impExlDataObj[i].MenuName;
			var RaqName=impExlDataObj[i].RaqName;
			var CSPName=impExlDataObj[i].CSPName;
			var AuxiliaryMenuName=impExlDataObj[i].AuxiliaryMenuName;
			var rec={};
			rec["MenuName"]=MenuName;
			rec["RaqName"]=RaqName;
			rec["CSPName"]=CSPName;
			rec["AuxiliaryMenuName"]=AuxiliaryMenuName;
			rec["IsExist"]=0;
			inputList.push(rec);
			gridData.push(MenuName);
			gridData.push(RaqName);
			gridData.push(CSPName);
			gridData.push(AuxiliaryMenuName);				
		}
		
		gridData=gridData.join();
		///从表中读取数据，然后判断要导入的数据与表里的数据是否重复	
		$.cm({ClassName:"web.DHCWL.V1.RptMgmt",MethodName:"ImpChk","inputList":gridData,wantreturnval:0
			},false,function(data){
				if("OK"==data.statusText){
					var jsonData=eval('('+data.responseText+')');
					var repDatas=jsonData.root,conKpiCode="";
					var rd,repD="",contFlag=false;

					for(var i=inputList.length-1;i>=0;i-- ){
						contFlag=false;
						rd=inputList[i];
						repD=rd.RaqName+"^"+rd.CSPName+"^"+rd.AuxiliaryMenuName;
						repD=repD.toUpperCase( );
						for(var j=repDatas.length-1;j>-1;j--){
							conKpiCode=repDatas[j].repData;
							if(conKpiCode.toUpperCase( )==repD){
								inputList[i].IsExist=1;	///数据是重复的。在grid中会以红色边框显示
							}
						} 
					}
					$('#rptmgmt-impDataGrid').datagrid({
						data:inputList
					});
					$('#rptmgmt-impDataGrid').datagrid('load');											
				}else{
					$.messager.alert("提示",data.responseText);
				}
			});	
	

	}

	///把grid记录写到后台表中
	function impDataFromFile() {
		var realInputList=[];
		var selImpList=$('#rptmgmt-impDataGrid').datagrid('getSelections');	
		if (selImpList.length==0) {
			$.messager.alert("提示","请选择需要导入的数据");
			return;
		}
		
		for(var i=0;i<=impExlDataObj.length-1;i++) {
			var RaqName=impExlDataObj[i].RaqName;
			var CSPName=impExlDataObj[i].CSPName;
			var AuxiliaryMenuName=impExlDataObj[i].AuxiliaryMenuName;
			for(var j=0;j<=selImpList.length-1;j++) {
				if (RaqName+"^"+CSPName+"^"+AuxiliaryMenuName==selImpList[j].RaqName+"^"+selImpList[j].CSPName+"^"+selImpList[j].AuxiliaryMenuName) {			
					for(var k=0;k<ImpFieldNames.length;k++) {
						var fieldName=ImpFieldNames[k];
						realInputList.push(impExlDataObj[i][fieldName]);
					}
				}
			}
		}

		$.cm({ClassName:"web.DHCWL.V1.RptMgmt",MethodName:"impFromExl","fieldNames":ImpFieldNames.join(),wantreturnval:1,inputList:realInputList.join(String.fromCharCode(2))},false,function(data){
					if("ok"==data.responseText){
						$('#rptmgmt-impDataDlg').dialog('close');
						rptmgmtGrid.load();	
						$.messager.alert("提示","导入成功！");
					}else{
						$.messager.alert("提示",data.responseText);
					}				
				});
	}
	
	var aryFieldName=new Array();
	///加载文件内容到数组
	function readImpDataFromFile(filePath){
		/*
			var str = "(function test(x){"+
			"var Shell = new ActiveXObject('Shell.Application');"+
			"var Message = '请选择文件';"+
			"var Folder = Shell.BrowseForFolder(0, Message, 0X0040, 0X11);"+
			"return Folder;}());";
			CmdShell.notReturn = 0;    //有返回值调用
			var rtn = CmdShell.EvalJs(str);     //运行代码且得到返回值
		*/
			var str = "(function test(x){"+
			"var xlApp = new ActiveXObject('Excel.Application');"+
            //http://127.0.0.1/dthealth/med/Results/Template/tpl.xlsx
            //"var xlBook = xlApp.Workbooks.Open('d:\\\\excelname.csv.xls');"+
            "var xlBook = xlApp.Workbooks.Open('"+filePath+"');"+
            "var xlSheet = xlBook.ActiveSheet;"+
            "var rtn = xlSheet.Cells(2,2).Value;"+
            "rtn += '^'+xlSheet.Cells(3,2).Value;"+
            "rtn += '^'+xlSheet.Cells(4,2).Value;"+
            "rtn += '^'+xlSheet.Cells(5,2).Value;"+
            "xlApp.Visible = true;"+
            "xlApp.UserControl = false;"+
            "xlBook.Close(savechanges=false);"+
            "xlApp.Quit();"+
            "xlSheet=null;"+
            "xlBook=null;"+
            "xlApp=null;"+
            "return rtn;}());";
            CmdShell.notReturn = 0;    //有返回值调用
			var rtn = CmdShell.EvalJs(str);     //运行代码且得到返回值 		
		
		
		
		
		
		aryFieldName.length=0;
		impExlDataObj.length=0;
		try {
	 		oXL = new ActiveXObject('Excel.Application');
	 	}catch (e) {
	 		alert("无法启动Excel!\n\n如果您确信您的电脑中已经安装了Excel，"+"那么请调整IE的安全级别。\n\n具体操作：\n\n"+"工具 → Internet选项 → 安全 → 自定义级别 → 对没有标记为安全的ActiveX进行初始化和脚本运行 → 启用");
	 		return false;
	 	}		

        //打开指定路径的excel文件   
		var oWB = oXL.Workbooks.open(filePath); 

		if (!oWB) {
			Ext.Msg.alert("提示","打开文件错误！请确认是否是正确的excel文件！");
			return;
		}
		var strImpData="";
		//操作第一个sheet(从一开始，而非零)   
		try {
			
			var sheetInx=1;
			oWB.worksheets(sheetInx).select();  
			var oSheet = oWB.ActiveSheet;  
			//使用的行数   
			var rows =oSheet.usedrange.rows.count+1; 
			//使用的列数
			var colCnt =oSheet.usedrange.Columns.Count;
			//var clsNameRowbegin=2;
			var fieldNameRowBegin=2;
			var dataRowBegin=4;
			var strDataset="";

			//取字段名称,并判断是否是正确的导入文件
			var isValidFile=0;
			for (var colInx = 1; colInx <= colCnt; colInx++) {
				var fieldName=oSheet.Cells(fieldNameRowBegin,colInx).value;
				aryFieldName.push(fieldName);
				if (fieldName=="MenuName") isValidFile=1;
			}
			if (isValidFile==0) {	
				oWB.Close();  
				//退出操作excel的实例对象   
				oXL.Application.Quit();  
				CollectGarbage();
				//Ext.Msg.alert("提示",e);
				$.messager.alert("提示","请确认是否是正确的导入文件！");
				return ;				
				
			}
			
			
			for (var i = dataRowBegin; i <= rows; i++) {
				var rec={};
				for (var j=1;j<=colCnt;j++) {
					var cellData=oSheet.Cells(i, j).value;
					if (cellData==undefined) cellData="";

					if (oSheet.Cells(i, j).NumberFormatLocal=="yyyy/m/d" || oSheet.Cells(i, j).NumberFormatLocal=="yyyy-m-d") {					
						var d = new Date(cellData);
						cellData=d.getFullYear() + '-' + (d.getMonth() + 1) + '-' + d.getDate() ;						
					}
					
					rec[aryFieldName[j-1]]=cellData;	
				}
				impExlDataObj.push(rec);	
			} 
			
	
		}catch(e) {  
			oWB.Close();  
			//退出操作excel的实例对象   
			oXL.Application.Quit();  
			CollectGarbage();
			//Ext.Msg.alert("提示",e);
			$.messager.alert("提示","打开文件错误！请确认是否是正确的导入文件！");

		}  

		oWB.Close();  
		//退出操作excel的实例对象   
		oXL.Application.Quit();  
		//手动调用垃圾收集器   
		CollectGarbage();         	

    }	

	///富文本编辑器。配置工具栏。
	CKEDITOR.editorConfig = function( config ) {
		config.toolbarGroups = [
			{ name: 'clipboard', groups: [ 'clipboard', 'undo' ] },
			{ name: 'document', groups: [ 'mode', 'document', 'doctools' ] },
			{ name: 'editing', groups: [ 'find', 'selection', 'spellchecker', 'editing' ] },
			{ name: 'forms', groups: [ 'forms' ] },
			'/',
			{ name: 'basicstyles', groups: [ 'basicstyles', 'cleanup' ] },
			{ name: 'paragraph', groups: [ 'list', 'indent', 'blocks', 'align', 'bidi', 'paragraph' ] },
			{ name: 'links', groups: [ 'links' ] },
			{ name: 'insert', groups: [ 'insert' ] },
			'/',
			{ name: 'styles', groups: [ 'styles' ] },
			{ name: 'colors', groups: [ 'colors' ] },
			{ name: 'tools', groups: [ 'tools' ] },
			{ name: 'others', groups: [ 'others' ] },
			{ name: 'about', groups: [ 'about' ] }
		];

		config.removeButtons = 'PasteText,PasteFromWord,Source,Save,NewPage,Preview,Print,Templates,Find,Replace,SelectAll,Scayt,Form,TextField,Textarea,Select,Button,ImageButton,HiddenField,RemoveFormat,Superscript,Subscript,Strike,NumberedList,BulletedList,Outdent,Indent,Blockquote,CreateDiv,BidiRtl,BidiLtr,Link,Unlink,Anchor,Image,Flash,Table,Smiley,HorizontalRule,SpecialChar,PageBreak,Iframe,Language,Styles,Format,Font,FontSize,TextColor,Maximize,About,ShowBlocks,BGColor';
	};

	
    ///富文本编辑器初始化
	CKEDITOR.replace( 'idckeditor', {
    	customConfig: 'custom/config_zhcx1.js'
	});	
	CKEDITOR.replace( 'idckeditor1', {
    	customConfig: 'custom/config_zhcx1.js'
	});	
	CKEDITOR.replace( 'idckeditor2', {
    	customConfig: 'custom/config_zhcx1.js'
	});	
	
	
	
};
$(init);

