/**
 * patientqry 病案查找
 * 
 * Copyright (c) 2018-2019 WHui. All rights reserved.
 * 
 * CREATED BY WHui 2019-12-01
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
	Common_ComboToHosp("cboHospital",'',Logon.HospID);
	Common_ComboToMrType("cboMrType",ServerObj.MrClass);
	$HUI.combobox('#cboHospital',{
		onSelect:function(rows){
			Common_ComboToLoc("cboDiscLoc","","E",rows["HospID"],'I','');			// 科室
			Common_ComboToLoc("cboDiscWard","","W",rows["HospID"],'','');			// 病区
		}
	});
	
	// 科室、病区联动
	$('#cboDiscLoc').combobox({
	    onChange:function(newValue,oldValue){
		    var Hosp = $("#cboHospital").combobox('getValue');
			Common_ComboToLoc("cboDiscWard","","W",Hosp,'','',newValue);			// 病区
	    }
	})
	

	InitgridVol();
}

function InitEvent(){
	$('#btnQry').click(function(){
		VolQry()
	});
	
	$('#btnClean').click(function(){
		Clean()
	});
	$('#txtMrNo').bind('keyup', function(event) {
	　　if (event.keyCode == "13") {
	　　　　VolQry();
	　　}
	});

	$('#txtFillNo').bind('keyup', function(event) {
	　　if (event.keyCode == "13") {
	　　　　VolQry();
	　　}
	});
	
	$('#txtRegNo').bind('keyup', function(event) {
	　　if (event.keyCode == "13") {
	　　　　VolQry();
	　　}
	});

	$('#txtPatName').bind('keyup', function(event) {
	　　if (event.keyCode == "13") {
	　　　　VolQry();
	　　}
	});

	$('#txtIDNumber').bind('keyup', function(event) {
	　　if (event.keyCode == "13") {
	　　　　VolQry();
	　　}
	});

	$('#txtKeyWord').bind('keyup', function(event) {
	　　if (event.keyCode == "13") {
	　　　　VolQry();
	　　}
	});
}
 /**
 * NUMS: M001
 * CTOR: WHui
 * DESC: 接诊日志
 * DATE: 2019-11-15
 * NOTE: 包括一个方法：InitgridVolQry
 * TABLE: 
 */
function InitgridVol(){
	var columns = [[
		{field:'PapmiNo',title:'登记号',width:100,align:'left'},
		{field:'MrNo',title:'病案号',width:100,align:'left'},
		{field:'PatName',title:'姓名',width:120,align:'left',sortable:'true',
			formatter: function(value,row,index){
				if (row.IsDeath==1){
					return row.PatName + "<span style='color: #FF4500'>(死亡)</span>";
				}else{
					return row.PatName;
				}
			}
		},
		{field:'Sex',title:'性别',width:50,align:'left'},
		{field:'Age',title:'年龄',width:50,align:'left'},
		{field:'Birthday',title:'出生日期',width:100,align:'left',sortable:'true'},
		{field:'VolStausDesc',title:'当前状态',width:80,align:'left'},	
		{field:'IdentityCode',title:'证件号码',width:170,align:'left'},
		{field:'AdmLocDesc',title:'就诊科室',width:120,align:'left'},
		{field:'AdmDate',title:'就诊日期',width:100,align:'left',sortable:'true'},
		{field:'DischLocDesc',title:'出院科室',width:120,align:'left'},
		{field:'DischDate',title:'出院日期',width:100,align:'left',sortable:'true'},
		{field:'BackDate',title:'回收日期',width:100,align:'left',sortable:'true'},
		{field:'MainDiag',title:'主要诊断',width:100,align:'left'},
		{field:'FirstOper',title:'手术',width:100,align:'left'},
		{field:'VistingDoctor',title:'主治医师',width:100,align:'left'},
		{field:'HomeProvince',title:'现住址/户籍地址',width:150,align:'left',
			formatter:function(value,row,index){
				var ret='';
				var HomeAddress	 = row["HomeAddress"];
				var RegAddress	 = row["RegAddress"];
				ret = HomeAddress+'/'+RegAddress;
				return ret;
			}
		},
		{field:'Company',title:'工作单位',width:100,align:'left'},
		{field:'VolID',title:'时间线',width:100,align:'left',
			formatter:function(value,row,index){
				if (value=="") return "";
				var VolID = row["VolID"];
				var btn='<a href="#" onclick="InitTimeLine(\'' + VolID + '\')">'+$g('时间线')+'</a>';
				return btn;
			}
		},
		{field:'EpisodeID',title:'编目信息',width:100,align:'left',
			formatter:function(value,row,index){
				if (value=="") return "";
				var EpisodeID = row["EpisodeID"];
				var IsCoded = row["IsCoded"];
				if (IsCoded==1) {
					var btn='<a href="#" onclick="openCodeFrontPage(\'' + EpisodeID + '\')">'+$g('编目信息')+'</a>';
				}else{
					var btn='<a href="#" onclick="openCodeFrontPage(\'' + -1 + '\')">'+$g('未编目')+'</a>';
				}
				return btn;
			}
		},
		{field:'RelativeName',title:'联系人',width:100,align:'left'}
	]];
	
	var gridVol = $HUI.datagrid("#gridVol",{
		view: detailview,	// *显示细节*
		fit:true,
		//title:"病案查找",
		headerCls:'panel-header-gray',
		iconCls:'icon-paper',
		pagination: true, //如果为true, 则在DataGrid控件底部显示分页工具栏
		rownumbers: true,		//如果为true, 则显示一个行号列
		autoRowHeight: false,	//定义是否设置基于该行内容的行高度。设置为 false，则可以提高加载性能
		loadMsg:'数据加载中...',
		pageSize: 20,
		fitColumns:false,		//设置为 true，则会自动扩大或缩小列的尺寸以适应网格的宽度并且防止水平滚动
		url:$URL,
		columns :columns,
		queryParams:{
		    ClassName:"MA.IPMR.SSService.PatientQry",
			QueryName:"QryVolumeList",
			aArgInput:'',
			rows:10000
		},
		detailFormatter:function(index,row){	// *显示细节*
			return '<div style="padding:10px"><table id="ddv-' + index + '"></table></div>';
		},
		onExpandRow:function(index,row){		// *显示细节*
			$('#ddv-'+index).datagrid({
				fit:false,
				rownumbers: true,
				fitColumns:false,		//设置为 true，则会自动扩大或缩小列的尺寸以适应网格的宽度并且防止水平滚动
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
					{field:'BatchNumber',title:'批次号',width:180,align:'left'},
					{field:'UserDesc',title:'操作人',width:180,align:'left'},
					{field:'ItemDesc',title:'操作项目',width:180,align:'left'},
					{field:'ActDate',title:'操作日期',width:180,align:'left',
						formatter:function(value,row,index){
							if (value=="") return "";
							var actDate = row["ActDate"];
							var actTime = row["ActTime"];
							return actDate+" "+actTime;
						}
					},
					{field:'ToUserDesc',title:'接收人',width:180,align:'left'},
					{field:'UpdoOperaDesc',title:'撤销标记',width:180,align:'left'},
					{field:'UpdoDate',title:'撤销日期',width:180,align:'left',
						formatter:function(value,row,index){
							if (value=="") return "";
							var updoDate = row["UpdoDate"];
							var updoTime = row["UpdoTime"];
							return updoDate+" "+updoTime;
						}
					},
					{field:'UpdoUserDesc',title:'撤销人',width:180,align:'left'},
					{field:'UpdoReason',title:'撤销原因',width:180,align:'left'}
				]],
				onResize:function(){
					$('#gridReceipt').datagrid('fixDetailRowHeight',index);
				},
				onLoadSuccess:function(){
					setTimeout(function(){
						$('#gridReceipt').datagrid('fixDetailRowHeight',index);
					},0);
				}
			});
			$('#gridVol').datagrid('fixDetailRowHeight',index);
		}
	});
	return gridVol;
}

// 查询
function VolQry(){
	var hospid		= $("#cboHospital").combobox('getValue');
	var mrtype		= $("#cboMrType").combobox('getValue');
	var mrno		= $("#txtMrNo").val();
	var regno		= $("#txtRegNo").val();
	var patname		= $("#txtPatName").val();
	var idnumber	= $("#txtIDNumber").val();
	var keyword		= $("#txtKeyWord").val();
	var admdatefrom	= $('#admDateFrom').datebox('getValue');
	var admdateto	= $('#admDateTo').datebox('getValue');
	var discdatefrom= $('#discDateFrom').datebox('getValue');
	var discdateto	= $('#discDateTo').datebox('getValue');
	var discloc		= $("#cboDiscLoc").combobox('getValue');
	var discward	= $("#cboDiscWard").combobox('getValue');
	var fillno		= $("#txtFillNo").val();
	
	var inputStr	= hospid;
	inputStr		+= '^' + mrtype;
	inputStr		+= '^' + mrno;
	inputStr		+= '^' + regno;
	inputStr		+= '^' + patname;
	inputStr		+= '^' + idnumber;
	inputStr		+= '^' + keyword;
	inputStr		+= '^' + admdatefrom;
	inputStr		+= '^' + admdateto;
	inputStr		+= '^' + discdatefrom;
	inputStr		+= '^' + discdateto;
	inputStr		+= '^' + discloc;
	inputStr		+= '^' + discward;
	inputStr		+= '^' + fillno;
	
	if (hospid==''){
		$.messager.popover({msg: '请选择医院！',type: 'alert',timeout: 1000});
		return '';
	}
	if (mrtype==''){
		$.messager.popover({msg: '请选择病案类型！',type: 'alert',timeout: 1000});
		return '';
	}
	if ((mrno=='')&&(fillno=='')&&(regno=='')&&(patname=='')&&(idnumber=='')&&(keyword=='')){
		$.messager.popover({msg: '请输入病案号、归档号、登记号、姓名、证件号码或关键字查询条件！',type: 'alert',timeout: 2000});
		return '';
	}
	if ((mrno=='')&&(fillno=='')&&(regno=='')&&(patname=='')&&(idnumber=='')){
		if (((admdatefrom=='')&&(admdateto!=''))||((admdatefrom!='')&&(admdateto==''))){
			$.messager.popover({msg: '请选择就诊日期查询条件！',type: 'alert',timeout: 1000});
			return '';
		}
		if (((discdatefrom=='')&&(discdateto!=''))||((discdatefrom!='')&&(discdateto==''))){
			$.messager.popover({msg: '请选择出院日期查询条件！',type: 'alert',timeout: 1000});
			return '';
		}
		if ((admdatefrom=='')&&(discdatefrom=='')){
			$.messager.popover({msg: '请选择就诊日期或出院日期查询条件！',type: 'alert',timeout: 1500});
			return '';
		}
	}else{
		$('#admDateFrom').datebox('setValue','');
		$('#admDateTo').datebox('setValue','');
		$('#discDateFrom').datebox('setValue','');
		$('#discDateTo').datebox('setValue','');
		$('#cboDiscWard').combobox('setValue','');
	}
	
	$('#gridVol').datagrid('load',  {
		ClassName:"MA.IPMR.SSService.PatientQry",
		QueryName:"QryVolumeList",
		aArgInput:inputStr,
		rows:10000
	});
	$('#gridVol').datagrid('unselectAll');
}

function Clean(){
	$('#admDateFrom').datebox('setValue','');
	$('#admDateTo').datebox('setValue','');
	$('#discDateFrom').datebox('setValue','');
	$('#discDateTo').datebox('setValue','');
	$('#cboDiscLoc').combobox('setValue','');
	$('#cboDiscWard').combobox('setValue','');
	$("#txtMrNo").val('');
	$("#txtRegNo").val('');
	$("#txtPatName").val('');
	$("#txtIDNumber").val('');
	$("#txtKeyWord").val('');
	$("#txtFillNo").val('');
	InitgridVol();
}
// 时间线
function InitTimeLine(aVolId){
	if (!aVolId) {
		$.messager.alert("错误","未获得卷号！","error");
		return;
	}
	/*
	var iWidth=(window.screen.availWidth-10)*0.6;                         //弹出窗口的宽度;
    var iHeight=(window.screen.availHeight-50)*0.8;                        //弹出窗口的高度;
	var iTop = (window.screen.height-30-iHeight)/2;       //获得窗口的垂直位置;
    var iLeft = (window.screen.width-10-iWidth)/2;        //获得窗口的水平位置;

	var strURL = "./ma.ipmr.ss.timeline.csp?VolID=" + aVolId;
	window.open(strURL,"_blank", "height="+iHeight+",width="+iWidth+',top='+iTop+',left='+iLeft+",status=yes,toolbar=no,menubar=no,scrollbars=yes");
	*/
	var strURL = "./ma.ipmr.ss.timeline.csp?VolID=" + aVolId;
	 var title='时间线';
	 websys_showModal({
	 	url:strURL,
	 	title:title,
	 	iconCls:'icon-w-list',  
	 	originWindow:window,
	 	closable:true,
	 	//minimizable:true, 最小化后不见了
	 	width:'80%',
	 	height:'80%',  //8.2以上版本支持百分比，8.2以下的用具体像素，如height:window.screen.availHeight-80,
	 });
}

// 编目信息
function openCodeFrontPage(aEpisodeID){
	if (!aEpisodeID) {
		$.messager.alert("错误","未获得就诊ID！","error");
		return;
	}/*
	var iWidth=(window.screen.availWidth-10)*0.9;                         //弹出窗口的宽度;
    var iHeight=(window.screen.availHeight-50)*0.9;                        //弹出窗口的高度;
	var iTop = (window.screen.height-30-iHeight)/2;       //获得窗口的垂直位置;
    var iLeft = (window.screen.width-10-iWidth)/2;        //获得窗口的水平位置;
	var strURL = "./ma.ipmr.fp.codefpinfo.csp?aEpisodeID=" + aEpisodeID+"&aCodeMultiVer=Clinical";
	window.open(strURL,"_blank", "height="+iHeight+",width="+iWidth+',top='+iTop+',left='+iLeft+",status=yes,toolbar=no,menubar=no,scrollbars=yes");
	*/
	var strURL = "./ma.ipmr.fp.codefpinfo.csp?aEpisodeID=" + aEpisodeID+"&aCodeMultiVer=Clinical";
	if ('undefined'!== typeof websys_getMWToken) {
		strURL+='&MWToken='+websys_getMWToken();
	}
	 var title='编目信息';
	 websys_showModal({
	 	url:strURL,
	 	title:title,
	 	iconCls:'icon-w-list',  
	 	originWindow:window,
	 	closable:true,
	 	//minimizable:true, 最小化后不见了
	 	width:'1200px',
	 	height:'702px',  //8.2以上版本支持百分比，8.2以下的用具体像素，如height:window.screen.availHeight-80,
	 });
}