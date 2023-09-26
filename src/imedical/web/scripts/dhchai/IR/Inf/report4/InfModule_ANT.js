function InitAnt(obj){

	// 抗菌药物信息
	obj.gridINFAnti = $("#gridINFAnti").DataTable({
		dom: 'rt',
		paging:false,
		select: 'single',
		ordering: false,
		ajax: {
			"url": "dhchai.query.datatables.csp",
			"data": function (d) {
				d.ClassName = "DHCHAI.IRS.INFAntiSrv";
				d.QueryName = "QryINFAntiByRep";
				d.Arg1 = ReportID;
				d.ArgCnt = 1;
			}
		},
		columns: [
			{"data": "AntiDesc"}
			,{"data": "SttDate"}
			,{"data": "EndDate"}
			,{"data": "MedPurpose"}
			,{"data": "PreMedEffect"}
			,{"data": "PreMedTime"}
			,{"data": "PostMedDays"}
		]
	});
	refreshgridINFAntiSync();  //为了自动管理抗菌药物
	
	function refreshgridINFAntiSync(){
		if(obj.gridINFAntiSync==undefined)
		{
			obj.gridINFAntiSync = $("#gridINFAntiSync").DataTable({
				dom: 'rt',
				paging:false,
				select: 'single',
				ordering: false,
				ajax: {
					"url": "dhchai.query.datatables.csp",
					"data": function (d) {
						d.ClassName = "DHCHAI.DPS.OEOrdItemSrv";
						d.QueryName = "QryOrdItemByEpisodeID";
						d.Arg1 = EpisodeID;
						d.Arg2 = '';
						d.Arg3 = '';
						d.Arg4 = '1';
						d.ArgCnt = 4;
					}
				},
				columns: [
					{"data": "OrdDesc"}
					// ,{"data": "Generic"}
					,{"data": "Priority"}
					,{"data": "SttDate"}
					,{"data": "XDate"}
					,{"data": "AntDrgPoison"}
					,{"data": "AntUsePurpose"}
					,{"data": "AntIsSubmiss", 
						render: function ( data, type, row ) {
							if (data=="1"){
								return '是';
							}else{
								return '否'
							}
						}
					}
				],
				createdRow: function( row, data, dataIndex ) {
					//alert(dataIndex);
					if(data["AntUsePurpose"].indexOf("预防")>=0)
					{
						var antStart = data["SttDate"];
						var SttDateTime = $.form.GetValue("txtOperSttDateTime");
						var OperDate = SttDateTime.split(' - ')[0];
						var rst = $.form.CompareDate(OperDate,antStart);
						if(rst>0)
						{
							InitINFAntiEditData(row,'');
							INFAntiAdd(row,'');
						}
						
					}					
				}
			});
			obj.gridINFAntiSync.on('dblclick', 'tr', function(e) {
				var selectedRows = obj.gridINFAntiSync.rows({selected: true}).count();
				if ( selectedRows !== 1 ) return;
				layer.closeAll();
				OpenINFAntiEdit(this);
			});
			/*
			obj.gridINFAntiSync.on( 'draw', function () {
				alert( 'Redraw occurred at: '+new Date().getTime() );
			});
			*/
		}else{
			obj.gridINFAntiSync.ajax.reload(function(){});
		}

	}
	// 弹出抗菌药物提取框
	function OpenINFAntiSync(){		
		obj.LayerOpenINFAntiSync = layer.open({
				type: 1,
				zIndex: 100,
				maxmin: false,
				title: "抗菌用药-提取[双击数据进行编辑]", 
				area: ['1200px','500px'],
				content: $('#LayerOpenINFAntiSync')
		});	
	}
	// 弹出抗菌药物编辑框
	function OpenINFAntiEdit(INFAntiSyncRows,INFAntiRows){
		obj.LayerOpenINFAntiEdit = layer.open({
				type: 1,
				zIndex: 100,
				maxmin: false,
				title: "抗菌用药-编辑", 
				area: ['700px','550px'],
				content: $('#LayerOpenINFAntiEdit'),
				btnAlign: 'c',
				btn: ['保存','取消'],
				yes: function(index, layero){
				  	// 添加数据
					INFAntiAdd(INFAntiSyncRows,INFAntiRows);
					// 关闭弹框
					layer.closeAll();
				}
				,success: function(layero){
					InitINFAntiEditData(INFAntiSyncRows,INFAntiRows);
				}
		});	
	}
	
	function INFAntiAdd(INFAntiSyncRows,INFAntiRows){
		var ID = '';
		var AntiUseID = '';
		var AntiDesc2 = '';
		if ((INFAntiRows!=undefined)&&(INFAntiRows!='')){
			var rd = obj.gridINFAnti.row(INFAntiRows).data();
			ID = rd.ID;
		}
		if ((INFAntiSyncRows!=undefined)&&(INFAntiSyncRows!='')){
			var rd = obj.gridINFAntiSync.row(INFAntiSyncRows).data();
			AntiUseID = rd.OrdItemID;
			AntiDesc2 = rd.Generic;
		}
		var AntiDesc = $.form.GetValue("txtAntiDesc");
		var DoseQty = $.form.GetValue("txtDoseQty");
		var DoseUnitID = $.form.GetValue("cboDoseUnit");
		if (DoseUnitID==''){
			var DoseUnit='';
		}else{
			var DoseUnit = $.form.GetText("cboDoseUnit");
		}
		var PhcFreqID = $.form.GetValue("cboPhcFreq");
		if (PhcFreqID==''){
			var PhcFreq='';
		}else{
			var PhcFreq = $.form.GetText("cboPhcFreq");
		}
		var MedUsePurposeID = $.form.GetValue("cboMedUsePurpose");
		if (MedUsePurposeID==''){
			var MedUsePurpose='';
		}else{
			var MedUsePurpose = $.form.GetText("cboMedUsePurpose");
		}
		var AdminRouteID = $.form.GetValue("cboAdminRoute");
		if (AdminRouteID==''){
			var AdminRoute='';
		}else{
			var AdminRoute = $.form.GetText("cboAdminRoute");
		}
		var MedPurposeID = $.form.GetValue("cboMedPurpose");
		if (MedPurposeID==''){
			var MedPurpose='';
		}else{
			var MedPurpose = $.form.GetText("cboMedPurpose");
		}
		var TreatmentModeID = $.form.GetValue("cboTreatmentMode");
		if (TreatmentModeID==''){
			var TreatmentMode='';
		}else{
			var TreatmentMode = $.form.GetText("cboTreatmentMode");
		}	
		var PreMedEffectID = $.form.GetValue("cboPreMedEffect");
		if (PreMedEffectID==''){
			var PreMedEffect='';
		}else{
			var PreMedEffect = $.form.GetText("cboPreMedEffect");
		}	
		var PreMedIndicatID = $.form.GetValue("cboPreMedIndicat");
		if (PreMedIndicatID==''){
			var PreMedIndicat='';
		}else{
			var PreMedIndicat = $.form.GetText("cboPreMedIndicat");
		}
		var CombinedMedID = $.form.GetValue("cboCombinedMed");
		if (CombinedMedID==''){
			var CombinedMed='';
		}else{
			var CombinedMed = $.form.GetText("cboCombinedMed");
		}
		var SttDate = $.form.GetValue("txtSttDate");
		var EndDate = $.form.GetValue("txtEndDate");
		var PreMedTime = $.form.GetValue("txtPreMedTime");
		var PostMedDays = $.form.GetValue("txtPostMedDays");
		var SenAnaID = $.form.GetValue("cboSenAna");
		if (SenAnaID==''){
			var SenAna='';
		}else{
			var SenAna = $.form.GetText("cboSenAna");
		}
		var row ={
			'ID':ID,
			'EpisodeID':EpisodeID,
			'ReportID':ReportID,
			'AntiUseID':AntiUseID,
			'AntiDesc':AntiDesc,
			'AntiDesc2':AntiDesc2,
			'SttDate':SttDate,
			'EndDate':EndDate,
			'DoseQty':DoseQty,
			'DoseUnitID':DoseUnitID,
			'DoseUnit':DoseUnit,
			'PhcFreqID':PhcFreqID,
			'PhcFreq':PhcFreq,
			'MedUsePurposeID':MedUsePurposeID,
			'MedUsePurpose':MedUsePurpose,
			'AdminRouteID':AdminRouteID,
			'AdminRoute':AdminRoute,
			'MedPurposeID':MedPurposeID,
			'MedPurpose':MedPurpose,
			'TreatmentModeID':TreatmentModeID,
			'TreatmentMode':TreatmentMode,
			'PreMedEffectID':PreMedEffectID,
			'PreMedEffect':PreMedEffect,
			'PreMedIndicatID':PreMedIndicatID,
			'PreMedIndicat':PreMedIndicat,
			'CombinedMedID':CombinedMedID,
			'CombinedMed':CombinedMed,
			'PreMedTime':PreMedTime,
			'PostMedDays':PostMedDays,
			'SenAnaID':SenAnaID,
			'SenAna':SenAna,
			'UpdateDate':'',
			'UpdateTime':'',
			',UpdateUserID':$.LOGON.USERID,
			'UpdateUser':''
		}
		if ((INFAntiRows==undefined)||(INFAntiRows=='')){
			obj.gridINFAnti.row.add(row).draw();
		}else{
			obj.gridINFAnti.row(INFAntiRows).data(row).draw();
		}
		
	}
	function InitINFAntiEditData(INFAntiSyncRows,INFAntiRows){
		var AntiDesc   = '';
		var DoseQty    = '';
		var DoseUnitID = '';
		var DoseUnit = '';
		var PhcFreqID ='';
		var PhcFreq = '';
		var MedUsePurposeID = '';
		var MedUsePurpose = '';
		var AdminRouteID = '';
		var AdminRoute = '';
		var MedPurposeID = '';
		var MedPurpose = '';
		var TreatmentModeID ='';
		var TreatmentMode = '';
		var PreMedEffectID = '';
		var PreMedEffect= '';
		var PreMedIndicatID = '';
		var PreMedIndicat = '';
		var CombinedMedID = '';
		var CombinedMed ='';
		var SttDate  = '';
		var EndDate = '';
		var PreMedTime = '';
		var PostMedDays = '';
		var SenAnaID = '';
		var SenAna ='';
		
		if ((INFAntiSyncRows!=undefined)&&(INFAntiSyncRows!='')){
			var rd = obj.gridINFAntiSync.row(INFAntiSyncRows).data();
			AntiDesc = rd.OrdDesc;
			MedPurposeID = rd.AntUsePurposeID;
			MedPurpose = rd.AntUsePurpose;
			SttDate = rd.SttDate;
			EndDate = rd.XDate;
		}
		if ((INFAntiRows!=undefined)&&(INFAntiRows!='')){
			var rd = obj.gridINFAnti.row(INFAntiRows).data();
			AntiDesc = rd.AntiDesc;
			MedPurposeID = rd.MedPurposeID;
			MedPurpose = rd.MedPurpose;
			SttDate = rd.SttDate;
			EndDate = rd.EndDate;
			PreMedEffectID = rd.PreMedEffectID;
			PreMedEffect = rd.PreMedEffect;
			PreMedTime = rd.PreMedTime;
			PostMedDays = rd.PostMedDays;
		}
		if(MedPurpose.indexOf("预防")>=0)
		{
			MedPurpose = "预防";
		}
		else
		{
			MedPurpose = "治疗";
		}
		// 渲染控件
		$.form.SelectRender('cboMedPurpose');
		$.form.SelectRender('cboPreMedEffect');
		$.form.DateRender('txtSttDate',SttDate);
		$.form.DateRender('txtEndDate',EndDate);
		// 控件赋值
		$.form.SetValue('txtAntiDesc',AntiDesc);		
		$.form.SetValue('cboMedPurpose',MedPurposeID,MedPurpose);
		$.form.SetValue('cboPreMedEffect',PreMedEffectID,PreMedEffect);
		$.form.SetValue('txtPreMedTime',PreMedTime);
		$.form.SetValue('txtPostMedDays',PostMedDays);
	}
	// 添加抗菌药物事件
	$("#btnINFAntiAdd").click(function(e){
		OpenINFAntiEdit();
	});
	// 抗菌药物提取事件
	$('#btnINFAntiSync').click(function(e){
		// TODO同步医嘱
		OpenINFAntiSync();
	});
	// 删除抗菌药物事件
	$("#btnINFAntiDel").click(function(e){
		var selectedRows = obj.gridINFAnti.rows({selected: true}).count();
		if (selectedRows!== 1 ) {
			layer.msg('请选择一行数据!',{icon: 2});
			return;
		}else{
			var rd = obj.gridINFAnti.rows({selected: true}).data().toArray()[0];
			obj.gridINFAnti.rows({selected:true}).remove().draw(false);
		}
	});
	// 抗菌药物信息列表双击事件
	obj.gridINFAnti.on('dblclick', 'tr', function(e) {
		var selectedRows = obj.gridINFAnti.rows({selected: true}).count();
		if ( selectedRows !== 1 ) return;
		OpenINFAntiEdit('',this);
	});

	obj.ANT_SaveData = function(){
		// 抗菌药物
    	var InputAnti = '';
    	for (var i=0;i<obj.gridINFAnti.data().length;i++){
    		var Input = obj.gridINFAnti.data()[i].ID;
    		Input = Input + CHR_1 + obj.gridINFAnti.data()[i].EpisodeID;
    		Input = Input + CHR_1 + obj.gridINFAnti.data()[i].AntiUseID;
    		Input = Input + CHR_1 + obj.gridINFAnti.data()[i].AntiDesc;
    		Input = Input + CHR_1 + obj.gridINFAnti.data()[i].AntiDesc2;
    		Input = Input + CHR_1 + obj.gridINFAnti.data()[i].SttDate;
    		Input = Input + CHR_1 + obj.gridINFAnti.data()[i].EndDate;
    		Input = Input + CHR_1 + obj.gridINFAnti.data()[i].DoseQty;
    		Input = Input + CHR_1 + obj.gridINFAnti.data()[i].DoseUnitID;
    		Input = Input + CHR_1 + obj.gridINFAnti.data()[i].PhcFreqID;
    		Input = Input + CHR_1 + obj.gridINFAnti.data()[i].MedUsePurposeID;
    		Input = Input + CHR_1 + obj.gridINFAnti.data()[i].AdminRouteID;
    		Input = Input + CHR_1 + obj.gridINFAnti.data()[i].MedPurposeID;
    		Input = Input + CHR_1 + obj.gridINFAnti.data()[i].TreatmentModeID;
    		Input = Input + CHR_1 + obj.gridINFAnti.data()[i].PreMedEffectID;
    		Input = Input + CHR_1 + obj.gridINFAnti.data()[i].PreMedIndicatID;
    		Input = Input + CHR_1 + obj.gridINFAnti.data()[i].CombinedMedID;
    		Input = Input + CHR_1 + obj.gridINFAnti.data()[i].PreMedTime;
    		Input = Input + CHR_1 + obj.gridINFAnti.data()[i].PostMedDays;
    		Input = Input + CHR_1 + obj.gridINFAnti.data()[i].SenAnaID;
    		Input = Input + CHR_1 + '';
    		Input = Input + CHR_1 + '';
    		Input = Input + CHR_1 + $.LOGON.USERID;
    		InputAnti = InputAnti + CHR_2 + Input;
    	}
    	if (InputAnti) InputAnti = InputAnti.substring(1,InputAnti.length);
    	return InputAnti;
	}
}