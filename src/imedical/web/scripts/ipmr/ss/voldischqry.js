/**
 * patientqry 出院查询
 * 
 * Copyright (c) 2018-2019 liyi. All rights reserved.
 * 
 * CREATED BY liyi 2020-05-13
 * 
 * 注解说明
 * TABLE: 
 */
//页面全局变量对象
var globalObj = {
	m_QryType:''
}

$(function(){
	//初始化
	Init();

	//事件初始化
	InitEvent();
})

function Init(){
	var tdateFrom	= Common_GetDate(-7,"");
	var tdateTo		= Common_GetDate(0,"");	
	$('#discDateFrom').datebox('setValue', tdateTo);		// 给日期框赋值
	$('#discDateTo').datebox('setValue', tdateTo);			// 给日期框赋值
	Common_ComboToHosp("cboHospital",'',Logon.HospID);
	Common_ComboToMrType("cboMrType",ServerObj.MrClass);
	Common_ComboToLocGroup('cboLocgroup','E','-');
	Common_ComboToDic("cboDateType","VolDisDateType",1,'');					// 初始化日期类型
	$('#cboDateType').combobox('select',ServerObj.DateTypeId);				// 选择默认日期类型
	
	// 医院、科室、病区联动
	$HUI.combobox('#cboHospital',{
		onSelect:function(rows){
			var LocGroup = $("#cboLocgroup").combobox('getValue');
			Common_ComboToLoc("cboDiscLoc","","E",rows["HospID"],ServerObj.MrClass,LocGroup);			// 科室
			Common_ComboToLoc("cboDiscWard","","W",rows["HospID"],'','');			// 病区
		}
	});

	// 科室组、科室联动
	$('#cboLocgroup').combobox({
	    onSelect:function(rows){
	    	var Hosp = $("#cboHospital").combobox('getValue');
			Common_ComboToLoc('cboDiscLoc','','E',Hosp,ServerObj.MrClass,rows["ID"]);
			Common_ComboToLoc("cboDiscWard","","W",Hosp,'','');			// 病区
	    }
	})
	
	// 科室、病区联动
	$('#cboDiscLoc').combobox({
	    onSelect:function(rows){
	    	var Hosp = $("#cboHospital").combobox('getValue');
			Common_ComboToLoc("cboDiscWard","","W",Hosp,'','',rows["ID"]);			// 病区
	    },
	    onChange:function(rows){
	    	var Hosp = $("#cboHospital").combobox('getValue');
	    	var LocID = $("#cboDiscLoc").combobox('getValue');
			Common_ComboToLoc("cboDiscWard","","W",Hosp,'','',LocID);			// 病区
	    }
	})
	InitgridDischVol();
}

function InitEvent(){
	$('#btnDischQry').click(function(){
		globalObj.m_QryType =3;
		$("#txtMrNo").val('');
		ReloadVol()
	});
	
	$('#btnNoBackQry').click(function(){
		globalObj.m_QryType = 1;
		$("#txtMrNo").val('');
		ReloadVol()
	});
	
	$('#btnBackQry').click(function(){
		globalObj.m_QryType = 2;
		$("#txtMrNo").val('');
		ReloadVol()
	});
	$('#btnEmrQry').click(function(){
		globalObj.m_QryType = 4;
		$("#txtMrNo").val('');
		ReloadVol()
	});
	$('#txtMrNo').bind('keyup', function(event) {
	　　if (event.keyCode == "13") {
	　　　　ReloadVol();
		   $("#txtMrNo").val('');
	　　}
	});
	$('#btnExport').click(function(){
		var data = $('#gridDischVol').datagrid('getData');
		if (data.rows.length==0)
		{
			$.messager.popover({msg: '请先查询再导出！',type: 'alert',timeout: 1000});
			return;
		}
		var filename ='';
		switch (globalObj.m_QryType)
		{
		case 1:
			filename='未回收病历'
			break;
		case 2:
			filename='已回收病历';
			break;
		case 3:
			filename='出院病历';
			break;
		default:
			filename='未提交病历';
			break;
		}
		$('#gridDischVol').datagrid('Export', {
			filename: filename,
			extension:'xls'
		});
	});
	
	$('#btnPrint').click(function(){
		var data = $('#gridDischVol').datagrid('getData');
		if (data.rows.length==0)
		{
			$.messager.popover({msg: '请先查询再打印！',type: 'alert',timeout: 1000});
			return;
		}
		var title ='';
		switch (globalObj.m_QryType)
		{
		case 1:
			title='未回收病历'
			break;
		case 2:
			title='已回收病历';
			break;
		case 3:
			title='出院病历';
			break;
		default:
			title='未提交病历';
			break;
		}
		$('#gridDischVol').datagrid('print', {
			title: title,
			model: '1',	// 通过后台
			columns:['PapmiNo','MrNo','PatName','Sex','DischLocDesc','DischDate','BackDate']
		});
	});
	$('#btnPrintSelect').click(function(){
		var data = $('#gridDischVol').datagrid('getData');
		if (data.rows.length==0)
		{
			$.messager.popover({msg: '请先查询再打印！',type: 'alert',timeout: 1000});
			return;
		}
		if ($('#gridDischVol').datagrid('getSelections').length==0){
			$.messager.popover({msg: '请勾选打印内容！',type: 'alert',timeout: 1000});
			return;
		}
		var title ='';
		switch (globalObj.m_QryType)
		{
		case 1:
			title='未回收病历'
			break;
		case 2:
			title='已回收病历';
			break;
		case 3:
			title='出院病历';
			break;
		default:
			title='未提交病历';
			break;
		}
		$('#gridDischVol').datagrid('print', {
			title: title,
			rows:$('#gridDischVol').datagrid('getSelections'),
			columns:['PapmiNo','MrNo','PatName','Sex','DischLocDesc','DischDate','BackDate']
		});
	});
}
 /**
 * NUMS: M001
 * CTOR: liyi
 * DESC: 出院病历
 * DATE: 2020-05-13
 * NOTE: 包括方法：InitgridDischVol，ReloadVol
 * TABLE: 
 */
function InitgridDischVol(){
	var columns = [[
		{field:'workList_ck',title:'sel',checkbox:true},
		{field:'PapmiNo',title:'登记号',align:'left'},
		{field:'MrNo',title:'病案号',align:'left'},
		{field:'PatName',title:'姓名',align:'left',
			formatter:function(value,row,index) {
				var VolID		= row.VolID;
				var PatName		= row.PatName;
				var HDischDate	= row.HDischDate;
				var EpisodeID   = row.EpisodeID;
				if (HDischDate!=""){
			   		return '<a href="#" class="grid-td-text-gray" onclick = synAdmInfo("' + EpisodeID + '")>' + PatName + '</a>';
			   	}else{
				   	return '<a href="#" class="grid-td-text-gray" onclick = synAdmInfo(' + "-1" + ')>' + PatName + '</a>';
				}
			}
		},
		{field:'AdmTimes',title:'住院次数',align:'left'},
		{field:'AdmDays',title:'住院天数',align:'left'},		
		{field:'Sex',title:'性别',align:'left'},
		{field:'Age',title:'年龄',align:'left'},
		{field:'VolStausDesc',title:'当前状态',align:'left'},
		{field:'DischLocDesc',title:'出院科室',align:'left'},
		{field:'DocName',title:'主管医生',align:'left'},
		{field:'EmrCompleteDesc',title:'医生提交',align:'left'},
		{field:'PayType',title:'病人类型',align:'left'},
		{field:'InsuranceNo',title:'医保卡号',align:'left'},
		{field:'UpStatus',title:'上传中天',align:'left','hidden':true,
			styler: function(value,row,index){
				if (value!='成功'){
					return 'color:red;';
				 }
		 	},
			formatter: function(value,row,index){
				if (row.UpStatus=='成功'){
					return '已上传';
				} else {
					return '未上传';
				}
			}
		},
		{field:'DischWardDesc',title:'出院病区',align:'left'},
		{field:'AdmDate',title:'入院日期',align:'left'},		
		{field:'DischDate',title:'出院日期',align:'left',sortable:true,
			styler: function(value,row,index){
				// 当HIS出院日期和病案出院日期不一致，改变行颜色
				if (row.DischDate !== row.HDischDate){
					return 'background-color:#FFE2E2;color:#BB0000;';
				}
			},
			/*formatter: function (value,row,index){
				if (row.DischDate !== row.HDischDate) {
					return "<span title='HIS出院日期为'"+row.HDischDate+">" + row.HDischDate + "</span>";
				}else{
					return row.DischDate;
				}
			}*/
			showTipFormatter:function(row,rowIndex){
				return "<span style='display:block;'>"+$g('出院日期')+"："+row['DischDate']+"</span>"
				+"<span style='display:block;'>"+$g('HIS出院日期')+"："+row['HDischDate']+"</span>";
			}
		},
		//{field:'HDischDate',title:'HIS出院日期',align:'left'},
		{field:'DeathDate',title:'死亡日期',align:'left'},
		{field:'BackDate',title:'回收日期',align:'left'},
		{field:'BackDays',title:'超期天数',align:'left',sortable:true,
			styler: function(value,row,index){
				// 间隔天数颜色改变:间隔超过三天变为红色，死亡患者间隔天数超过七天变为暗红色
				if (!row.DeathDate) {
					if (row.BackDays > 3){
						return 'background-color:#FFFAE8;color:#FFA200;'; 
					}
				} else {
					if (row.BackDays > 7){
						return 'background-color:#FFE2E2;color:#BB0000;';
					}
				}
			}
		}

	]];
	
	var gridDischVol = $HUI.datagrid("#gridDischVol",{
		fit:true,
		//title:"出院查询",
		headerCls:'panel-header-gray',
		iconCls:'icon-paper',
		singleSelect:false,
		pagination: true, 		//如果为true, 则在DataGrid控件底部显示分页工具栏
		rownumbers: true,		//如果为true, 则显示一个行号列
		autoRowHeight: false,	//定义是否设置基于该行内容的行高度。设置为 false，则可以提高加载性能
		loadMsg:'数据加载中...',
		pageSize: 20,
		fitColumns:false,		//设置为 true，则会自动扩大或缩小列的尺寸以适应网格的宽度并且防止水平滚动
		url:$URL,
		queryParams:{
		    ClassName:"MA.IPMR.SSService.VolDischQry",
			QueryName:"QryDischVol",
			aHospID:$("#cboHospital").combobox('getValue'),
			aMrTypeID:$("#cboMrType").combobox('getValue'),
			aDateFrom:$("#discDateFrom").datebox('getValue'),
			aDateTo:$("#discDateTo").datebox('getValue'),
			aLocGrpID:$("#cboLocgroup").combobox('getValue'),
			aLocID:$("#cboDiscLoc").combobox('getValue'),
			aWardID:$("#cboDiscWard").combobox('getValue'),
			aDeathFlag:($("#chkDeath").checkbox('getValue')?1:''),
			aQryType:globalObj.m_QryType,
			aDischDateWarn:($("#chkDischDateWarn").checkbox('getValue')?1:''),
			aQryDateType:getDateTypeCode(),
			aInDays:$("#txtInDays").val(),
			aMrNo:$("#txtMrNo").val(),
			rows:10000
		},onCheck:function(index, row){
			if ((!(typeof window.parent.SetChildPatNo == "function"))&&(!(typeof window.parent.ChangePerson === "function"))) {
				var frm=dhcsys_getmenuform();
				if (frm){
					frm.EpisodeID.value=row["HisEpisodeID"];
					//frm.PatientID.value=row["PatientID"];
				}
			}
		},
		columns :columns
	});
}


function ReloadVol(){
	var DateType = $("#cboDateType").combobox('getValue');
	if (DateType==""){
		$.messager.popover({msg: '日期类型不允许为空！',type:'alert',timeout: 1000});
		return
	}
	
	$('#gridDischVol').datagrid('load',  {
		ClassName:"MA.IPMR.SSService.VolDischQry",
		QueryName:"QryDischVol",
		aHospID:$("#cboHospital").combobox('getValue'),
		aMrTypeID:$("#cboMrType").combobox('getValue'),
		aDateFrom:$("#discDateFrom").datebox('getValue'),
		aDateTo:$("#discDateTo").datebox('getValue'),
		aLocGrpID:$("#cboLocgroup").combobox('getValue'),
		aLocID:$("#cboDiscLoc").combobox('getValue'),
		aWardID:$("#cboDiscWard").combobox('getValue'),
		aDeathFlag:($("#chkDeath").checkbox('getValue')?1:''),
		aQryType:globalObj.m_QryType,
		aDischDateWarn:($("#chkDischDateWarn").checkbox('getValue')?1:''),
		aQryDateType:getDateTypeCode(),
		aInDays:$("#txtInDays").val(),
		aMrNo:$("#txtMrNo").val(),
		rows:10000
	});
	$('#gridDischVol').datagrid('unselectAll');
}

function synAdmInfo(EpisodeID){
	if (EpisodeID=="-1"){
		$.messager.popover({msg: 'HIS无出院日期不允许同步！',type:'alert',timeout: 1000});
		return
	}
	$.messager.confirm("删除", "确定同步就诊数据?", function (r) {
		if (r) {
			$m({
				ClassName:"MA.IPMR.SSService.AdmSrv",
				MethodName:"SyncAdm",
				aEpisodeID:EpisodeID
			},function(txtData){
				ReloadVol();
			});
		} else {}
	});
}

function getDateTypeCode(){
	var DateTypeId = $("#cboDateType").combobox('getValue');
	if (DateTypeId=="") {
		$.messager.popover({msg:"请选择日期类型！",type:'alert',timeout: 1000});
		return;
	}
	
	var DateTypeCode = '';
	var jsonData = $cm({
		ClassName:"CT.IPMR.BT.Dictionary",
		MethodName:"GetObjById",
		aId:DateTypeId
	},false);
	DateTypeCode = jsonData.BDCode;
	
	return DateTypeCode;
}