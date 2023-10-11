/**
 * volstatusqry 状态查询
 * 
 * CREATED BY zhouyang 2019-12-19
 * 
 * 注解说明
 * TABLE: 
 */

//页面全局变量对象
var globalObj = {
}

$(function(){
	//初始化
	Init();
	
	//事件初始化
	InitEvent();
})

function Init(){
	$('#dbDateFrom').datebox('setValue', Common_GetDate(-7,""));							// 给日期框赋值
	$('#dbDateTo').datebox('setValue',Common_GetDate(0,""));								// 给日期框赋值
	Common_ComboToHosp("cboHospital",'',Logon.HospID);
	Common_ComboToMrType('cboMrType',ServerObj.MrClass);
	Common_ComboToLocGroup('cboLocGroup','E','-');

	// 医院、科室联动
	$('#cboHospital').combobox({
	    onSelect:function(rows){
	    	var LocGroup = $("#cboLocGroup").combobox('getValue');
			Common_ComboToLoc('cboLoc','','E',rows["HospID"],ServerObj.MrClass,LocGroup);
	    }
	})

	// 科室组、科室联动
	$('#cboLocGroup').combobox({
	    onSelect:function(rows){
	    	var Hosp = $("#cboHospital").combobox('getValue');
			Common_ComboToLoc('cboLoc','','E',Hosp,ServerObj.MrClass,rows["ID"]);
	    }
	})
	
	$HUI.combobox('#cboMrType',{
		onSelect:function(rows){
			var workFItem = rows["WorkFlowID"];
			Common_ComboToWorkFItem("cboWorkFItem",workFItem,"O");						
		}
	});
	//Common_ComboGridToUser("cboOperator","")
	
	InitGridVolStatus();	//初始化状态查询表格
}


function InitEvent(){

	$('#btnCurStatusQry').click(function(){
		StatusQry("C")
	});

	$('#btnNotDoneQry').click(function(){
		StatusQry("U")
	});

	$('#btnExport').click(function(){
		Export()
	});
}

 /**
 * NUMS: D001
 * CTOR: ZHOUYANG
 * DESC: 状态查询列表展现模块
 * DATE: 2019-12-19
 * NOTE: 包括方法：InitGridVolStatus，Export
 * TABLE: 
 */
function InitGridVolStatus()
{
	var datefrom=$('#dbDateFrom').datebox('getValue');	//获取日期控件的值
	var dateto=$('#dbDateTo').datebox('getValue');		//获取日期控件的值
	
	var columns = [[
		{field:'PapmiNo',title:'登记号',width:150,align:'left'},
		{field:'PatName',title:'姓名',width:150,align:'left'},
		{field:'MrNo',title:'病案号',width:120,align:'left'},
		{field:'Sex',title:'性别',width:100,align:'left'},
		{field:'Age',title:'年龄',width:60,align:'left'},
		{field:'StatusDesc',title:'当前状态',width:100,align:'left'},
		{field:'DischLocDesc',title:'出院科室',width:150,align:'left'},
		{field:'DischWardDesc',title:'出院病区',width:150,align:'left'},
		{field:'AdmDate',title:'就诊日期',width:150,align:'left'},
		{field:'DischDate',title:'出院日期',width:100,align:'left'},
		{field:'BackDate',title:'回收日期',width:100,align:'left'},
		{field:'VolID',title:'卷ID',hidden:true,order:'asc'},
	]];
	var gridVolStatus = $HUI.datagrid("#gridVolStatus",{
		view: detailview,		// 显示细节
		fit:true,
		//title:"卷状态查询",
		headerCls:'panel-header-gray',
		iconCls:'icon-paper',
		pagination: true, 		// 如果为true, 则在DataGrid控件底部显示分页工具栏
		rownumbers: true,		// 如果为true, 则显示一个行号列
		singleSelect:true,
		autoRowHeight: false,	// 定义是否设置基于该行内容的行高度。设置为 false，则可以提高加载性能
		loadMsg:'数据加载中...',
		pageSize: 20,
		fitColumns:true,		// 设置为 true，则会自动扩大或缩小列的尺寸以适应网格的宽度并且防止水平滚动
		url:$URL,
		queryParams:{
		    ClassName	: "MA.IPMR.SSService.VolStatusQry",
			QueryName	: "QryVolumeList",
			aHospID		: $("#cboHospital").combobox('getValue'),
			aMrTypeID	: ServerObj.MrClass,
			aDateFrom	: datefrom,
			aDateTo		: dateto,
			aLocGrpID	: '',
			aLocID		: '',
			aOperaUser	: '',
			aQryFlag	: '',
			rows		: 10000
		},
		columns :columns,
		detailFormatter:function(index,row){	// 显示细节
			return '<div style="padding:10px"><table id="ddv-' + index + '"></table></div>';
		},
		onExpandRow:function(index,row){		// 显示细节
			$('#ddv-'+index).datagrid({
				fit:false,
				rownumbers: true,
				fitColumns:false,		// 设置为 true，则会自动扩大或缩小列的尺寸以适应网格的宽度并且防止水平滚动
				singleSelect:true,
				height:'auto',
				url:$URL,
				queryParams:{
				    ClassName:"MA.IPMR.SSService.VolStatusQry",
					QueryName:"QryStatusList",
					aVolumeID:row.VolID,
					rows:100
				},
				columns:[[
					{field:'BatchNumber',title:'批次号',width:'180',align:'left'},
					{field:'UserDesc',title:'操作人',width:'180',align:'left'},
					{field:'ItemDesc',title:'操作项目',width:'180',align:'left'},
					{field:'ActDate',title:'操作日期',width:'180',align:'left',
						formatter:function(value,row,index){
							if (value=="") return "";
							var actDate = row["ActDate"];
							var actTime = row["ActTime"];
							return actDate+" "+actTime;
						}
					},
					{field:'ToUserDesc',title:'接收人',width:'180',align:'left'},
					{field:'UpdoOperaDesc',title:'撤销标记',width:'180',align:'left'},
					{field:'UpdoDate',title:'撤销日期',width:'180',align:'left',
						formatter:function(value,row,index){
							if (value=="") return "";
							var updoDate = row["UpdoDate"];
							var updoTime = row["UpdoTime"];
							return updoDate+" "+updoTime;
						}
					},
					{field:'UpdoUserDesc',title:'撤销人',width:'180',align:'left'},
					{field:'UpdoReason',title:'撤销原因',width:'180',align:'left'}
				]],
				onResize:function(){
					$('#gridVolStatus').datagrid('fixDetailRowHeight',index);
				},
				onLoadSuccess:function(){
					setTimeout(function(){
						$('#gridVolStatus').datagrid('fixDetailRowHeight',index);
					},0);
				}
			});
			$('#gridVolStatus').datagrid('fixDetailRowHeight',index);
		}
	});
}

function StatusQry(queryflg)
{
	var hospital 	= $("#cboHospital").combobox('getValue');
	var mrtype  	= $("#cboMrType").combobox('getValue');
	var wfitem 		= $("#cboWorkFItem").combobox('getValue');
	var datefrom 	= $('#dbDateFrom').datebox('getValue');
	var dateto 		= $('#dbDateTo').datebox('getValue');
	var locgroup	= $("#cboLocGroup").combobox('getValue');
	var loc  		= $("#cboLoc").combobox('getValue');
	var operauser 	= ''; //$("#cboOperator").combobox('getValue');
	var wfitemDesc 		= $("#cboWorkFItem").combobox('getText');
	if(typeof(queryflg)=='undefined')
	{
		queryflg = '';
	}
	
	if(wfitem == '')
	{
		$.messager.popover({msg: '请选择操作项目！',type: 'alert',timeout: 1000});
		return '';
	}

	//修改表格标题
	if( queryflg == "C")
	{
		$('#gridVolStatus').datagrid('options').title="当前状态查询结果-"+wfitemDesc;
		$("#gridVolStatus").datagrid("getPanel").panel("setTitle","当前状态查询结果-"+wfitemDesc)
	}else if(queryflg == "U")
	{
		$('#gridVolStatus').datagrid('options').title="未处理查询结果-"+wfitemDesc;
		$("#gridVolStatus").datagrid("getPanel").panel("setTitle","未处理查询结果-"+wfitemDesc)
	}else{
		
	}
	
	//重载状态查询表格
	$('#gridVolStatus').datagrid('reload',{
		ClassName	: "MA.IPMR.SSService.VolStatusQry",
		QueryName	: "QryVolumeList",
		aHospID		: hospital,
		aMrTypeID	: mrtype,
		aWFItemID	: wfitem,
		aDateFrom	: datefrom,
		aDateTo		: dateto,
		aLocGrpID	: locgroup,
		aLocID		: loc,
		aOperaUser	: operauser,
		aQryFlag	: queryflg,
		rows		: 10000
	})
	$('#gridVolStatus').datagrid('unselectAll');
}

//导出
function Export()
{
	var data = $('#gridVolStatus').datagrid('getData');
	if (data.rows.length==0)
	{
		$.messager.popover({msg: '请先查询再导出！',type: 'alert',timeout: 1000});
		return;
	}
	var gridoptions = $('#gridVolStatus').datagrid('options');
	var filename = gridoptions.title;
	
	$('#gridVolStatus').datagrid('Export', {
		filename: filename,
		extension:'xls'
	});
}