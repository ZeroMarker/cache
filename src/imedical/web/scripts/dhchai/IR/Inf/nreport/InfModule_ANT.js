function InitAnt(obj){
	obj.refreshgridINFAnti = function(){
		if(obj.gridINFAnti==undefined)
		{
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
						d.Arg2 = '';
						d.ArgCnt = 2;
					}
				},
				columns: [
					{"data": "AntiDesc"}
					,{"data": "SttDate"}
					,{"data": "EndDate"}
					,{"data": "DoseQty"}
					,{"data": "DoseUnit"}
					,{"data": "PhcFreq"}
					,{"data": "MedUsePurpose"}
					,{"data": "AdminRoute"}
					,{"data": "MedPurpose"}
					,{"data": "TreatmentMode"}
					,{"data": "PreMedEffect"}
					,{"data": "PreMedIndicat"}
					,{"data": "CombinedMed"}
					,{"data": "PreMedTime"}
					,{"data": "PostMedDays"}
					,{"data": "SenAna"}
				]
			});
		}else{
			obj.gridINFAnti.ajax.reload(function(){});
		}
	}
	obj.refreshgridINFAnti();

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
						d.ClassName = "DHCHAI.IRS.INFAntiSrv";
						d.QueryName = "QryINFAntiByRep";
						d.Arg1 = '';
						d.Arg2 = EpisodeID;
						d.ArgCnt = 2;
					}
				},
				columns: [
					{"data": "AntiDesc"}
					,{"data": "SttDate"}
					,{"data": "EndDate"}
					,{"data": "DoseQty"}
					,{"data": "DoseUnit"}
					,{"data": "PhcFreq"}
					,{"data": "AdminRoute"}
					,{"data": "MedPurpose"}
				]
			});
			obj.gridINFAntiSync.on('dblclick', 'tr', function(e) {
				var data  = obj.gridINFAntiSync.row(this).data();
				if (typeof(data)=='undefined') return;
				layer.closeAll();
				OpenINFAntiEdit(data,'');
			});
		}else{
			obj.gridINFAntiSync.ajax.reload(function(){});
		}

	}
	// 弹出抗菌药物提取框
	function OpenINFAntiSync(){
		refreshgridINFAntiSync();
		obj.LayerOpenINFAntiSync = layer.open({
				type: 1,
				zIndex: 100,
				maxmin: false,
				title: "抗菌用药-提取[双击数据进行编辑]", 
				area: '75%',
				content: $('#LayerOpenINFAntiSync')
		});	
	}
	// 弹出抗菌药物编辑框
	function OpenINFAntiEdit(d,r){
		obj.LayerOpenINFAntiEdit = layer.open({
				type: 1,
				zIndex: 100,
				maxmin: false,
				title: "抗菌用药-编辑", 
				area: ['700px',''],
				content: $('#LayerOpenINFAntiEdit'),
				btnAlign: 'c',
				btn: ['保存','取消'],
				yes: function(index, layero){
				  	// 添加数据
					INFAntiAdd(d,r);
				}
				,success: function(layero){
					InitINFAntiEditData(d,r);
				}
		});	
	}
	
	function INFAntiAdd(d,r){
		var ID = '';
		var AntiUseID = '';
		var AntiDesc2 = '';
		if (d){
			ID = d.ID;
			AntiUseID = d.AntiUseID;
			AntiDesc2 = d.AntiDesc2;
		}
		var AntiDesc = $.form.GetText("cboAnti");
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
		if (($.form.GetValue("cboAnti")=='')&&(AntiDesc=='--请选择--')){
    		layer.msg('医嘱名不能为空!',{icon: 2});
			return;
    	}
    	if (DoseQty==''){
    		layer.msg('剂量不能为空!',{icon: 2});
			return;
    	}
    	if (DoseUnit==''){
    		layer.msg('剂量单位不能为空!',{icon: 2});
			return;
    	}
    	if (PhcFreq==''){
    		layer.msg('频次不能为空!',{icon: 2});
			return;
    	}
		if (MedUsePurpose==''){
    		layer.msg('用途不能为空!',{icon: 2});
			return;
    	}
    	if (AdminRoute==''){
    		layer.msg('给药途径不能为空!',{icon: 2});
			return;
    	}
    	if (MedPurpose==''){
    		layer.msg('目的不能为空!',{icon: 2});
			return;
    	}
    	if (TreatmentMode==''){
    		layer.msg('治疗用药方式不能为空!',{icon: 2});
			return;
    	}
    	if (PreMedEffect==''){
    		//layer.msg('预防用药效果不能为空!',{icon: 2});
			//return;
    	}
    	if (PreMedIndicat==''){
    		//layer.msg('预防用药指征不能为空!',{icon: 2});
			//return;
    	}
    	if (CombinedMed==''){
    		layer.msg('联合用药不能为空!',{icon: 2});
			return;
    	}
    	if (SttDate==''){
    		layer.msg('开始日期不能为空!',{icon: 2});
			return;
    	}
    	if (EndDate==''){
    		layer.msg('结束日期不能为空!',{icon: 2});
			return;
    	}
		if (!$.form.CompareDate(EndDate,SttDate)){
			layer.msg('结束日期不能在开始日期之前!',{icon: 2});
			return;
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

		// 数据重复标志
    	var dataRepeatFlg = 0;
    	for (var i=0;i<obj.gridINFAnti.data().length;i++){
    		if (r) {
    			if ($(r).context._DT_RowIndex==i){
    				continue;
    			}
    		}
    		if ((AntiDesc==obj.gridINFAnti.data()[i].AntiDesc)&&(SttDate==obj.gridINFAnti.data()[i].SttDate)){
    			dataRepeatFlg = 1;
    		}
    	}
    	if (dataRepeatFlg == 1) {
    		layer.confirm('存在开始日期、抗生素相同的记录,是否添加抗生素信息？', {
			  btn: ['是','否'] //按钮
			}, function(){
				InsertAnti(r,row);
			});
    	}else{
    		InsertAnti(r,row);
    	};
	}

	function InsertAnti(r,row){
		if (r){  //修改
			var rowIndex = $(r).context._DT_RowIndex; //行号
			obj.gridINFAnti.row(r).data(row).draw();
		}else{	//添加
			obj.gridINFAnti.row.add(row).draw();
		}
		// 关闭弹框
		layer.closeAll();
	}

	function InitINFAntiEditData(d,r){
		// 渲染控件
		$.form.SelectRender('cboDoseUnit');
		$.form.SelectRender('cboPhcFreq');
		$.form.SelectRender('cboMedUsePurpose');
		$.form.SelectRender('cboAdminRoute');
		$.form.SelectRender('cboMedPurpose');
		$.form.SelectRender('cboTreatmentMode');
		$.form.SelectRender('cboPreMedEffect');
		$.form.SelectRender('cboPreMedIndicat');
		$.form.SelectRender('cboCombinedMed');
		$.form.SelectRender('cboSenAna');
		$.form.SelectRender('cboAnti');
		// 控件赋值
		if (d){
			$.form.DateRender('txtSttDate',d.SttDate,'top-right');
			$.form.DateRender('txtEndDate',d.EndDate,'top-right');
			$.form.SetValue('cboAnti','',d.AntiDesc);
			$.form.SetValue('txtDoseQty',d.DoseQty);
			$.form.SetValue('cboDoseUnit',d.DoseUnitID,d.DoseUnit);
			$.form.SetValue('cboPhcFreq',d.PhcFreqID,d.PhcFreq);
			$.form.SetValue('cboMedUsePurpose',d.MedUsePurposeID,d.MedUsePurpose);
			$.form.SetValue('cboAdminRoute',d.AdminRouteID,d.AdminRoute);
			$.form.SetValue('cboMedPurpose',d.MedPurposeID,d.MedPurpose);
			$.form.SetValue('cboTreatmentMode',d.TreatmentModeID,d.TreatmentMode);
			$.form.SetValue('cboPreMedEffect',d.PreMedEffectID,d.PreMedEffect);
			$.form.SetValue('cboPreMedIndicat',d.PreMedIndicatID,d.PreMedIndicat);
			$.form.SetValue('cboCombinedMed',d.CombinedMedID,d.CombinedMed);
			$.form.SetValue('cboSenAna',d.SenAnaID,d.SenAna);
			$.form.SetValue('txtPreMedTime',d.PreMedTime);
			$.form.SetValue('txtPostMedDays',d.PostMedDays);
		}else{
			$.form.DateRender('txtSttDate','','top-right');
			$.form.DateRender('txtEndDate','','top-right');
			$.form.SetValue('cboAnti','','');
			$.form.SetValue('txtDoseQty','');
			$.form.SetValue('cboDoseUnit','','');
			$.form.SetValue('cboPhcFreq','','');
			$.form.SetValue('cboMedUsePurpose','','');
			$.form.SetValue('cboAdminRoute','','');
			$.form.SetValue('cboMedPurpose','','');
			$.form.SetValue('cboTreatmentMode','','');
			$.form.SetValue('cboPreMedEffect','','');
			$.form.SetValue('cboPreMedIndicat','','');
			$.form.SetValue('cboCombinedMed','','');
			$.form.SetValue('cboSenAna','','');
			$.form.SetValue('txtPreMedTime','');
			$.form.SetValue('txtPostMedDays','');
		}
		if ((typeof InitSelectLoad) == "function"){
			InitSelectLoad();
		}
	}
	// 添加抗菌药物事件
	$("#btnINFAntiAdd").click(function(e){
		OpenINFAntiEdit('','');
	});
	// 抗菌药物提取事件
	$('#btnINFAntiSync').click(function(e){
		// TODO同步医嘱
		$.Tool.RunServerMethod('DHCHAI.DI.DHS.SyncHisInfo','SyncAdmOEOrdItem',HISCode,EpisodeIDx,ServiceDate,ServiceDate);
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
			layer.confirm('是否删除抗菌用药：'+rd.AntiDesc+'？', {
			  btn: ['是','否'] //按钮
			}, function(){
				obj.gridINFAnti.rows({selected:true}).remove().draw(false);
				layer.msg('删除抗菌用药成功！', {icon: 1});
			});
			// obj.gridINFAnti.rows({selected:true}).remove().draw(false);
		}
	});
	// 抗菌药物信息列表双击事件
	obj.gridINFAnti.on('dblclick', 'tr', function(e) {
		var data  = obj.gridINFAnti.row(this).data();
		if (typeof(data)=='undefined') return;
		OpenINFAntiEdit(data,this);
	});

	obj.ANT_Save = function(){
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