function InitICD(obj){
	// 同步病人诊断
	$.Tool.RunServerMethod('DHCHAI.DI.DHS.SyncHisInfo','SyncAdmDiagnos',$.LOGON.HISCode,EpisodeIDx,'','');
	// 疾病诊断列表
	obj.gridINFICD = $("#gridINFICD").DataTable({
		dom: 'rt',
		paging:false,
		select: 'single',
		ordering: false,
		ajax: {
			"url": "dhchai.query.datatables.csp",
			"data": function (d) {
				d.ClassName = "DHCHAI.IRS.INFICDSrv";
				d.QueryName = "QryINFICDByRep";
				d.Arg1 = ReportID;
				d.Arg2 = EpisodeID;
				d.ArgCnt = 2;
			}
		},
		columns: [
			{"data": "ICDDesc"}
			,{"data": "ICDDate"}
			,{"data": "ICDTime"}
		]
	});
	
	// function refreshgridINFICDSync(){
	// 	if(obj.gridINFICDSync==undefined)
	// 	{
	// 		obj.gridINFICDSync = $("#gridINFICDSync").DataTable({
	// 			dom: 'rt',
	// 			paging:false,
	// 			select: 'single',
	// 			ordering: false,
	// 			ajax: {
	// 				"url": "dhchai.query.datatables.csp",
	// 				"data": function (d) {
	// 					d.ClassName = "DHCHAI.DPS.MRDiagnosSrv";
	// 					d.QueryName = "QryDiagByEpisodeID";
	// 					d.Arg1 = EpisodeID;
	// 					d.Arg2 = '';
	// 					d.ArgCnt = 2;
	// 				}
	// 			},
	// 			columns: [
	// 				{"data": "ICD10"}
	// 				,{"data": "DiagDesc"}
	// 				,{"data": "DiagTpDesc"}
	// 				,{"data": "DiagDate"}
	// 				,{"data": "DiagTime"}
	// 				,{"data": "DiagNote"}
	// 				,{"data": "DiagSource"}
	// 				,{"data": "ID","visible" : false}
	// 				,{"data": "DiagTpCode","visible" : false}
	// 			]
	// 		});
	// 		obj.gridINFICDSync.on('dblclick', 'tr', function(e) {
	// 			layer.closeAll();
	// 			OpenINFICDEidt(this);
	// 		});
	// 	}else{
	// 		obj.gridINFICDSync.ajax.reload(function(){});
	// 	}
	// }

	// // 打开诊断编辑弹出框
	// function OpenINFICDEidt(INFICDSyncrows,INFICDprows){
	// 	var DiagTime='';
	// 	var DiagDate='';
	// 	var DiagDesc='';
	// 	var DiagDateTime='';
	// 	if ((INFICDSyncrows!=undefined)&&(INFICDSyncrows!='')){
	// 		var rd = obj.gridINFICDSync.row(INFICDSyncrows).data();
	// 		obj.MRDiagnosID = rd.ID;
	// 		DiagTime = rd.DiagTime;
	// 		DiagDate = rd.DiagDate;
	// 		DiagDesc = rd.DiagDesc;
	// 		DiagDateTime = DiagDate+' - '+DiagTime
	// 	}
	// 	if ((INFICDprows!=undefined)&&(INFICDprows!='')){
	// 		var rd = obj.gridINFICD.row(INFICDprows).data();
	// 		obj.MRDiagnosID = rd.MRDiagID;
	// 		DiagTime = rd.ICDTime;
	// 		DiagDate = rd.ICDDate;
	// 		DiagDesc = rd.ICDDesc;
	// 		DiagDateTime = DiagDate+' - '+DiagTime
	// 	}
	// 	obj.LayerINFICDEidt = layer.open({
	// 			type: 1,
	// 			zIndex: 100,
	// 			maxmin: false,
	// 			title: "诊断信息-编辑", 
	// 			area: ['400px','250px'],
	// 			content: $('#LayerINFICDEidt'),
	// 			btnAlign: 'c',
	// 			btn: ['保存','取消'],
	// 			yes: function(index, layero){
	// 				INFICDAdd(INFICDSyncrows,INFICDprows);
	// 			}
	// 			,success: function(layero){
	// 				$.form.SelectRender1('cboMrICDDx',2);
	// 				$.form.DateTimeRender1('DiagDateTime',DiagDateTime);
	// 				$("#cboMrICDDx").append(new Option(DiagDesc, '-1', false, true));
	// 			}
	// 	});	
	// }

	// // 添加诊断信息
	// function INFICDAdd(INFICDSyncrows,INFICDprows){
	// 	var ID = '';
	// 	var MRDiagID = '';
	// 	var ICDDesc2 ='';
	// 	if ((INFICDSyncrows!=undefined)&&(INFICDSyncrows!='')){
	// 		var rd = obj.gridINFICDSync.row(INFICDSyncrows).data();
	// 		ID = '';
	// 		MRDiagID = rd.ID;
	// 		ICDDesc2='';
	// 	}
	// 	if ((INFICDprows!=undefined)&&(INFICDprows!='')){
	// 		var rd = obj.gridINFICD.row(INFICDprows).data();
	// 		ID = rd.ID;
	// 		MRDiagID = rd.MRDiagID;
	// 		ICDDesc2='';
	// 	}
	// 	var ICDID = $.form.GetValue("cboMrICDDx");
	// 	if (ICDID=='-1') ICDID = '';
	// 	var ICDDesc = $.form.GetText("cboMrICDDx");
	// 	var DiagDateTime = $.form.GetValue("DiagDateTime");
	// 	var DiagDate = DiagDateTime.split(' - ')[0];
	// 	var DiagTime = DiagDateTime.split(' - ')[1];
	// 	if ((ICDDesc=='')||(DiagDateTime=='')){
	// 		layer.msg('诊断、时间不能为空!',{icon: 2});
	// 		return;
	// 	}
	// 	if (!obj.checkDate(DiagDate)){
	// 		layer.msg('诊断时间需要在住院期间!',{icon: 2});
	// 		return;
	// 	}
	// 	var data ={
	// 		'ID':ID,
	// 		'EpisodeID':EpisodeID,
	// 		'ReportID':ReportID,
	// 		'MRDiagID':MRDiagID,
	// 		'ICDDesc':ICDDesc,
	// 		'ICDDesc2':ICDDesc2,
	// 		'ICDDate':DiagDate,
	// 		'ICDTime':DiagTime,
	// 		'UpdateDate':'',
	// 		'UpdateTime':'',
	// 		'UpdateUserID':$.LOGON.USERID,
	// 		'UpdateUser':''
	// 	}
	// 	if ((INFICDprows==undefined)||(INFICDprows=='')){
	// 		obj.gridINFICD.row.add(data).draw();
	// 	}else{
	// 		obj.gridINFICD.row(INFICDprows).data(data).draw();
	// 	}
	// 	layer.closeAll();
	// }

	// // 提取数据按钮
	// $("#btnINFICDSync").click(function(e){


	// 	refreshgridINFICDSync();
	// 	obj.LayerINFICDSync= layer.open({
	// 			type: 1,   //0(信息框,默认) 1(页面层)  2(iframe层) 3(加载层) 4(tips层)
	// 			zIndex: 100,
	// 			maxmin: false,
	// 			title: "诊断信息-提取[双击数据进行编辑]", 
	// 			area: ['800px','400px'],
	// 			content: $('#LayerINFICDSync')
	// 	});	
	// });

	// // 删除按钮
	// $("#btnINFICDDel").click(function(e){
	// 	var selectedRows = obj.gridINFICD.rows({selected: true}).count();
	// 	if (selectedRows!== 1 ) {
	// 		layer.msg('请选择一行数据!',{icon: 2});
	// 		return;
	// 	}else{
	// 		var rd = obj.gridINFICD.rows({selected: true}).data().toArray()[0];
	// 		obj.gridINFICD.rows({selected:true}).remove().draw(false);
	// 	}
	// });

	// // 添加按钮
	// $("#btnINFICDAdd").click(function(e){
	// 	obj.MRDiagnosID='';
	// 	OpenINFICDEidt();
	// });

	// // 诊断列表双击
	// obj.gridINFICD.on('dblclick', 'tr', function(e) {
	// 	OpenINFICDEidt('',this);
	// });

	obj.ICD_SaveData = function(){
		// 诊断信息
    	var ICDs = '';
    	for (var i=0;i<obj.gridINFICD.data().length;i++){
    		var Input = obj.gridINFICD.data()[i].ID;
    		Input = Input + CHR_1 + obj.gridINFICD.data()[i].EpisodeID;
    		Input = Input + CHR_1 + obj.gridINFICD.data()[i].MRDiagID;
    		Input = Input + CHR_1 + obj.gridINFICD.data()[i].ICDDesc;
    		Input = Input + CHR_1 + obj.gridINFICD.data()[i].ICDDesc2;
    		Input = Input + CHR_1 + obj.gridINFICD.data()[i].ICDDate;
    		Input = Input + CHR_1 + obj.gridINFICD.data()[i].ICDTime;
    		Input = Input + CHR_1 + $.LOGON.USERID;
    		ICDs = ICDs + CHR_2 + Input;
    	}
    	if (ICDs) ICDs = ICDs.substring(1,ICDs.length);
    	return ICDs;
	}
}