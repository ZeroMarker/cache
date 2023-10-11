/**
 * 归档率查询
 * 注解说明
 * TABLE: 
 */
//页面全局变量对象
var globalObj = {
	m_QryType:'',
	// add for 欢迎界面点击
	m_wHospID	: ServerObj.wHospID,
	m_wMrTypeID	: ServerObj.wMrTypeID,
	m_wDateFrom	: ServerObj.wDateFrom,
	m_wDateTo	: ServerObj.wDateTo,
	m_wLocGrpID	: ServerObj.wLocGrpID,
	m_wLocID	: ServerObj.wLocID,
	m_wFlg		: ServerObj.wFlg
}

$(function(){
	//初始化
	Init();

	//事件初始化
	InitEvent();
})

function Init(){
	var tdateFrom	= Common_GetDate("","FIRST");
	var tdateTo		= Common_GetDate("","LAST");	
	$('#discDateFrom').datebox('setValue', tdateFrom);		// 给日期框赋值
	$('#discDateTo').datebox('setValue', tdateTo);			// 给日期框赋值
	Common_ComboToHosp("cboHospital",'',Logon.HospID);
	Common_ComboToMrType("cboMrType",ServerObj.MrClass);
	Common_ComboToLocGroup('cboLocgroup','E','-');
	
	// 医院、科室、病区联动
	$HUI.combobox('#cboHospital',{
		onSelect:function(rows){
			var LocGroup = $("#cboLocgroup").combobox('getValue');
			Common_ComboToLoc("cboDiscLoc","","E",rows["HospID"],ServerObj.MrClass,LocGroup);			// 科室
		}
	});

	// 科室组、科室联动
	$('#cboLocgroup').combobox({
	    onSelect:function(rows){
	    	var Hosp = $("#cboHospital").combobox('getValue');
			Common_ComboToLoc('cboDiscLoc','','E',Hosp,ServerObj.MrClass,rows["ID"]);
	    }
	})
	
	InitgridLateStatis();
}

function InitEvent(){
	$('#btnQry').click(function(){
		ReloadgridLateStatis()
	});
	
	$('#btnExport').click(function(){
		var data = $('#gridLateStatis').datagrid('getData');
		if (data.rows.length==0)
		{
			$.messager.popover({msg: '请先查询再导出！',type: 'alert',timeout: 1000});
			return;
		}
		$('#gridLateStatis').datagrid('Export', {
			filename: '归档统计',
			extension:'xls'
		});
	});

	$('#dtl_export').click(function() {
		var data = $('#gridVolDtl').datagrid('getData');
		if (data.rows.length==0)
		{
			$.messager.popover({msg: '请先查询再导出！',type: 'alert',timeout: 1000});
			return;
		}
		
		$('#gridVolDtl').datagrid('Export', {
			filename: '归档明细',
			extension:'xls'
		});
	});
}
 /**
 * NUMS: M001
 * CTOR: liyi
 * DESC: 归档统计
 * DATE: 2020-05-13
 * NOTE: 包括方法：InitgridLateStatis，ReloadgridLateStatis
 * TABLE: 
 */
function InitgridLateStatis(){
	if (globalObj.m_wFlg==1){
		Common_ComboToLoc("cboDiscLoc","","E",globalObj.m_wHospID,ServerObj.MrClass,'');
		$('#cboHospital').combobox('setValue',globalObj.m_wHospID);
		$('#cboMrType').combobox('setValue',globalObj.m_wMrTypeID);
		$('#discDateFrom').datebox('setValue', globalObj.m_wDateFrom);
		$('#discDateTo').datebox('setValue', globalObj.m_wDateTo);
		$('#cboLocgroup').combobox('setValue',globalObj.m_wLocGrpID);
		$('#cboDiscLoc').combobox('setValue',globalObj.m_wLocID);
	}
	
	var columns = [[
		{field: 'StatLocDesc',title: '科室', width: 150, align: 'left'},
		{field: 'DischCnt',title: '出院人数', width: 60, align: 'left',
			formatter:function(value,row,index) {
            	var StatLocID = row.StatLocID;
            	var BackDays  = -10
            	if(StatLocID=="-") StatLocID=""
				var DeathFlg="''";
               	return '<a href="#" class="grid-td-text-gray" onclick = showVolDtl(\''+ StatLocID + '\','+BackDays+','+DeathFlg+')>' + value + '</a>';            
            }		
		},
		{field: 'Dis1DLateCnt',title: '1日归档人数', width: 80,  align: 'left',
			formatter:function(value,row,index) {
           		var StatLocID = row.StatLocID;
            	var BackDays  = 1
           	    if(StatLocID=="-") StatLocID=""
				var DeathFlg="''";
                return '<a href="#" class="grid-td-text-gray" onclick = showVolDtl(\''+ StatLocID + '\','+BackDays+','+DeathFlg+')>' + value + '</a>';                     	
			}
		},
		{field: 'Dis2DLateCnt', title: '2日归档人数', width: 80, align: 'left',
			formatter:function(value,row,index) {
           		var StatLocID = row.StatLocID;
            	var BackDays  = 2
           	    if(StatLocID=="-") StatLocID=""
				var DeathFlg="''";
                return '<a href="#" class="grid-td-text-gray" onclick = showVolDtl(\''+ StatLocID + '\','+BackDays+','+DeathFlg+')>' + value + '</a>';                     	
			}
		},
		{field: 'Dis3DLateCnt',title: '3日归档人数', width: 80, align: 'left',
			formatter:function(value,row,index) {
           		var StatLocID = row.StatLocID;
            	var BackDays  = 3
           	    if(StatLocID=="-") StatLocID=""
				var DeathFlg="''";
                return '<a href="#" class="grid-td-text-gray" onclick = showVolDtl(\''+ StatLocID + '\','+BackDays+','+DeathFlg+')>' + value + '</a>';                     	
			}
		},
		{field: 'Dis5DLateCnt',title: '5日归档人数', width: 80, align: 'left',
			formatter:function(value,row,index) {
           		var StatLocID = row.StatLocID;
            	var BackDays  = 5
           	    if(StatLocID=="-") StatLocID=""
				var DeathFlg="''";
                return '<a href="#" class="grid-td-text-gray" onclick = showVolDtl(\''+ StatLocID + '\','+BackDays+','+DeathFlg+')>' + value + '</a>';                     	
			}
		},
		{field: 'Dis7DLateCnt',title: '7日归档人数', width: 80,  align: 'left',
			formatter:function(value,row,index) {
           		var StatLocID = row.StatLocID;
            	var BackDays  = 7
           	    if(StatLocID=="-") StatLocID=""
				var DeathFlg="''";
                return '<a href="#" class="grid-td-text-gray" onclick = showVolDtl(\''+ StatLocID + '\','+BackDays+','+DeathFlg+')>' + value + '</a>';                     	
			}
		},
		{field: 'Dis1DLateRatio',title: '1日归档率', width: 70,  align: 'left'},
		{field: 'Dis2DLateRatio',title: '2日归档率', width: 70,  align: 'left'},
		{field: 'Dis3DLateRatio',title: '3日归档率', width: 70,  align: 'left'},
		{field: 'Dis5DLateRatio',title: '5日归档率', width: 70,  align: 'left'},
		{field: 'Dis7DLateRatio',title: '7日归档率', width: 70,  align: 'left'},
		{field: 'DeathCnt',title: '死亡人数', width: 60,  align: 'left'},
		{field: 'Dth6DLateCnt',title: '6日归档人数', width: 80,  align: 'left',
			formatter:function(value,row,index) {
           		var StatLocID = row.StatLocID;
            	var BackDays  = 6
           	    if(StatLocID=="-") StatLocID=""
				var DeathFlg=1;
                return '<a href="#" class="grid-td-text-gray" onclick = showVolDtl(\''+ StatLocID + '\','+BackDays+','+DeathFlg+')>' + value + '</a>';                     	
			}
		},
		{field: 'Dth6DLateRatio',title: '6日归档率', width: 70,  align: 'left'},
		/*
		{field:'d',title:'明细',width:45,align:'left',
			formatter:function(value,row,index) {
            	var StatLocID = row.StatLocID;
            	if(StatLocID=="-") StatLocID=""
               	return '<a href="#" class="grid-td-text-gray" onclick = showVolDtl(' + StatLocID + ')>' + '明细' + '</a>';            
            }
		}*/
	]];	
	var gridLateStatis = $HUI.datagrid("#gridLateStatis",{
		fit:true,
		//title:"归档统计",
		headerCls:'panel-header-gray',
		iconCls:'icon-w-list',
		singleSelect:true,
		pagination: true, 		//如果为true, 则在DataGrid控件底部显示分页工具栏
		rownumbers: true,		//如果为true, 则显示一个行号列
		autoRowHeight: false,	//定义是否设置基于该行内容的行高度。设置为 false，则可以提高加载性能
		loadMsg:'数据加载中...',
		pageSize: 20,
		fitColumns:true,		//设置为 true，则会自动扩大或缩小列的尺寸以适应网格的宽度并且防止水平滚动
		url:$URL,
		queryParams:{
		    ClassName:"MA.IPMR.SSService.VolLateQry",
			QueryName:"QryVolBackStatis",
			aHospID:$("#cboHospital").combobox('getValue'),
			aMrTypeID:$("#cboMrType").combobox('getValue'),
			aDateFrom:$("#discDateFrom").datebox('getValue'),
			aDateTo:$("#discDateTo").datebox('getValue'),
			aLocGrpID:$("#cboLocgroup").combobox('getValue'),
			aLocID:$("#cboDiscLoc").combobox('getValue'),
			rows:10000
		},
		columns :columns
	});
}


function ReloadgridLateStatis(){
	$('#gridLateStatis').datagrid('load',  {
		ClassName:"MA.IPMR.SSService.VolLateQry",
		QueryName:"QryVolBackStatis",
		aHospID:$("#cboHospital").combobox('getValue'),
		aMrTypeID:$("#cboMrType").combobox('getValue'),
		aDateFrom:$("#discDateFrom").datebox('getValue'),
		aDateTo:$("#discDateTo").datebox('getValue'),
		aLocGrpID:$("#cboLocgroup").combobox('getValue'),
		aLocID:$("#cboDiscLoc").combobox('getValue'),
		rows:10000
	});
	$('#gridLateStatis').datagrid('unselectAll');
}

 /**
 * NUMS: M002
 * CTOR: liyi
 * DESC: 归档明细
 * DATE: 2020-05-13
 * NOTE: 包括方法：showVolDtl
 * TABLE: 
 */
function showVolDtl(StatLocID,BackDays,DeathFlg) {
	var DiscLoc = $("#cboDiscLoc").combobox('getValue');
	var QryLocID=""
	if (StatLocID!="")
	{
		QryLocID = StatLocID;
	}else{
		QryLocID = DiscLoc;
	}
	var icdColumns = [[
		{field: 'PapmiNo', title: '登记号', width: 100, align: 'left'},
		{field: 'PatName', title: '姓名', width: 100, align: 'left'},
		{field: 'MrNo', title: '病案号', width: 100, align: 'left'},
		{field: 'DocName', title: '主管医生', width:120, align: 'left'},
		{field: 'DischLocDesc', title: '出院科室', width: 150, align: 'left'},
		{field: 'DischWardDesc', title: '出院病区', width:150, align: 'left'},
		{field: 'DischDate', title: '出院日期', width: 100, align: 'left'},
		{field: 'BackDate', title: '回收日期',width:100 ,align: 'left'},
		{field: 'DeathDate', title: '死亡日期', width: 100, align: 'left'},
		{field: 'BackDays', title: '迟归天数', width: 100, align: 'left'}
	]];
	var gridVolDtl= $HUI.datagrid("#gridVolDtl", {
		fit: true,
		rownumbers : true, 
		singleSelect : true,
		pagination : true, 
		autoRowHeight : false,
		loadMsg : '数据加载中...',
		pageSize : 10,
		fitColumns : true,
		url : $URL,
	    queryParams : {
		    ClassName : "MA.IPMR.SSService.VolLateQry",
			QueryName : "QryVolBackStatDtl",
			aHospID:$("#cboHospital").combobox('getValue'),
			aMrTypeID:$("#cboMrType").combobox('getValue'),
			aDateFrom:$("#discDateFrom").datebox('getValue'),
			aDateTo:$("#discDateTo").datebox('getValue'),
			aLocGrpID:$("#cboLocgroup").combobox('getValue'),
			aLocID:QryLocID,
			aBackDays:BackDays,	
			aDeathFlg:DeathFlg,
			rows:10000
	    },
	    columns : icdColumns
	});

    var VolDtlDialog = $('#VolDtlDialog').dialog({
	    title: '归档明细',
		iconCls:'icon-w-list',
	    width: 1200,
        height: 560,
	    minimizable:false,
		maximizable:false,
		maximizable:false,
		collapsible:false,
	    closed: false,
	    cache: false,
	    modal: true
	});
	return;
}