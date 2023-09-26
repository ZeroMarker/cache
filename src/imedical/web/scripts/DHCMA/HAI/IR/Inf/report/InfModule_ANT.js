function InitAnt(obj){
	obj.AntiRowID = ''; //抗菌用药选中行
	obj.AntiUseID = '';

	obj.refreshgridINFAnti = function(){	
		// 抗菌用药信息
		obj.gridINFAnti = $HUI.datagrid("#gridINFAnti",{ 
			title:'抗菌用药'+'<span style="margin-left:30px;padding:6px 15px;background-color:#e3f7ff;color:#1278b8;border: 1px solid #c0e2f7;border-radius: 5px;"><span class="icon-tip-blue" style="margin-right:5px;">&nbsp;&nbsp;&nbsp;&nbsp;</span><span style="color:#1278b8;font-weight: 700;">提示信息：仅选择与此次感染相关的抗菌用药信息</span></span>',
			headerCls:'panel-header-gray',
			iconCls:'icon-paper',
			rownumbers: true, //如果为true, 则显示一个行号列
			singleSelect: true,
			autoRowHeight: false, //定义是否设置基于该行内容的行高度。设置为 false，则可以提高加载性能
			loadMsg:'数据加载中...',
			columns:[[
				{field:'AntiDesc',title:'抗生素',width:140},
				{field:'SttDate',title:'开始日期',width:90},
				{field:'EndDate',title:'结束日期',width:90},
				{field:'DoseQty',title:'剂量',width:45},
				{field:'DoseUnit',title:'剂量<br>单位',width:45},
				{field:'PhcFreq',title:'频次',width:100},
				{field:'MedUsePurpose',title:'用途',width:80},
				{field:'AdminRoute',title:'给药途径',width:80},
				{field:'MedPurpose',title:'目的',width:60},
				{field:'TreatmentMode',title:'治疗用药<br>方式',width:75},
				{field:'PreMedEffect',title:'预防用药<br>效果',width:75},
				{field:'PreMedIndicat',title:'预防用药<br>指征',width:70},
				{field:'CombinedMed',title:'联合用药',width:75},
				{field:'PreMedTime',title:'术前用药<br>时间(分钟)',width:75},
				{field:'PostMedDays',title:'术后用药<br>天数',width:65},
				{field:'SenAna',title:'敏感度',width:55}
			]],
			onSelect:function(rindex,rowData){
				if (obj.AntiRowID === rindex) {
					obj.AntiRowID="";
					$("#btnINFAntiDel").linkbutton("disable");
					obj.gridINFAnti.clearSelections();  //清除选中行
				} else {
					obj.AntiRowID = rindex;
					$("#btnINFAntiDel").linkbutton("enable");
				}		
			},
			onDblClickRow:function(rindex, rowdata) {
				if (rindex>-1) {
					OpenINFAntiEdit(rowdata,rindex);
				}
			},
			onLoadSuccess:function(data){
				$("#btnINFAntiDel").linkbutton("disable");
			}
		});
		
		if (ReportID) {	
			$cm ({
				ClassName:"DHCHAI.IRS.INFAntiSrv",
				QueryName:"QryINFAntiByRep",		
				aReportID: ReportID
			},function(rs){
				$('#gridINFAnti').datagrid('loadData', rs);				
			});	
		}
	}
	obj.refreshgridINFAnti();
	
	 // 抗菌用药提取事件
	$('#btnINFAntiSync').click(function(e){
		/// TODO同步医嘱
		$m({
			ClassName:"DHCHAI.DI.DHS.SyncHisInfo",
			MethodName:"SyncAdmOEOrdItem",
			aSCode:HISCode,
			aEpisodeIDX:EpisodeIDx,
			aDateFrom:ServiceDate,
			aDateTo:ServiceDate
		});
		OpenINFAntiSync();
	});
	//抗菌用药提取弹出事件
	obj.LayerOpenINFAntiSync = function () {
		$HUI.dialog('#LayerOpenINFAntiSync',{
			title:"抗菌用药-提取 [双击数据进行编辑]", 
			iconCls:'icon-w-paper',
			width: 1200,    
			height: 500, 
			modal: true,
			shadow:true,
			isTopZindex:true
		});
	}
	// 弹出抗菌用药提取框
	function OpenINFAntiSync(){
		refreshgridINFAntiSync();
		$('#LayerOpenINFAntiSync').show();
		obj.LayerOpenINFAntiSync();
	}
    //抗菌用药列表
	function refreshgridINFAntiSync(){	
		obj.gridINFAntiSync = $HUI.datagrid("#gridINFAntiSync",{
			fit:true,
			headerCls:'panel-header-gray',
			iconCls:'icon-paper',
			rownumbers: true, //如果为true, 则显示一个行号列
			singleSelect: true,
			autoRowHeight: false, //定义是否设置基于该行内容的行高度。设置为 false，则可以提高加载性能
			loadMsg:'数据加载中...',
			url:$URL,
			queryParams:{
				ClassName:'DHCHAI.IRS.INFAntiSrv',
				QueryName:'QryINFAntiByRep',
				aEpisodeID:EpisodeID
			},
			columns:[[
				{field:'AntiDesc',title:'医嘱名称',width:300},
				{field:'SttDate',title:'开始日期',width:120},
				{field:'EndDate',title:'结束日期',width:120},
				{field:'DoseQty',title:'剂量',width:100},
				{field:'DoseUnit',title:'剂量单位',width:100},
				{field:'PhcFreq',title:'频次',width:120},
				{field:'AdminRoute',title:'给药途径',width:120},
				{field:'MedPurpose',title:'使用目的',width:150}
			]],	
			onDblClickRow:function(rindex, rowdata) {
				if (rindex>-1) {
					OpenINFAntiEdit(rowdata,'');
					$HUI.dialog('#LayerOpenINFAntiSync').close();
				}
			}		
		});		
	}
	
	// 添加 抗菌用药事件
	$("#btnINFAntiAdd").click(function(e){
		OpenINFAntiEdit('','');	
	});
	
	// 弹出抗菌用药弹框
	function OpenINFAntiEdit(d,r){
		$('#LayerOpenINFAntiEdit').show();
		obj.LayerOpenINFAntiEdit();	
		$HUI.dialog('#LayerOpenINFAntiEdit',{
			buttons:[{
				text:'保存',
				handler:function(){	
					INFAntiAdd(d,r);
				}
			},{
				text:'取消',
				handler:function(){$HUI.dialog('#LayerOpenINFAntiEdit').close();}
			}]
		});
		InitINFAntiEditData(d);
	}
	
	// 抗菌用药弹框
	obj.LayerOpenINFAntiEdit = function() {
		$HUI.dialog('#LayerOpenINFAntiEdit',{
			title:'抗菌用药-编辑',
			iconCls:'icon-w-paper',
			width: 800,    
			modal: true,
			shadow:true,
			isTopZindex:true
		});
	}
	
	// 抗菌用药编辑框信息初始化
	function InitINFAntiEditData(d){
		obj.cboAnti = $HUI.lookup("#cboAnti", {
			panelWidth:450,
			url:$URL,
			editable: true,
			mode:'remote',      //当设置为 'remote' 模式时，用户输入的值将会被作为名为 'q' 的 http 请求参数发送到服务器，以获取新的数据。
			isValid:true,
			pagination:true,
			loadMsg:'正在查询',	
			isCombo:true,             //是否输入字符即触发事件，进行搜索
			minQueryLen:1,             //isCombo为true时，可以搜索要求的字符最小长度
			valueField: 'ID',
			textField: 'BTAnitDesc',
			queryParams:{ClassName: 'DHCHAI.DPS.OEAntiMastMapSrv',QueryName: 'QryOEAntiMastMap'},
			columns:[[     
				{field:'BTAnitDesc',title:'抗菌用药名称',width:400}  
			]],
			onBeforeLoad:function(param){
				var desc=param['q'];
				//if (desc=="") return false;  
				param = $.extend(param,{aAlias:desc}); //将参数q转换为类中的参数
			},
			onSelect:function(index,rowData){  
				obj.AntiUseID = rowData['ID'];				
			}
		});
		
		obj.cboDoseUnit = Common_ComboDicID("cboDoseUnit","OEDoseUnit");
		obj.cboPhcFreq = Common_ComboDicID("cboPhcFreq","OEPhcFreq");
		obj.cboMedUsePurpose = Common_ComboDicID("cboMedUsePurpose","AntiMedUsePurpose");
		obj.cboAdminRoute = Common_ComboDicID("cboAdminRoute","AntiAdminRoute");
		obj.cboMedPurpose = Common_ComboDicID("cboMedPurpose","AntiMedPurpose");
		obj.cboTreatmentMode = Common_ComboDicID("cboTreatmentMode","AntiTreatmentMode");
		obj.cboPreMedEffect = Common_ComboDicID("cboPreMedEffect","AntiPreMedEffect");
		obj.cboPreMedIndicat = Common_ComboDicID("cboPreMedIndicat","AntiPreMedIndicat");
		obj.cboCombinedMed = Common_ComboDicID("cboCombinedMed","AntiCombinedMed");
		obj.cboSenAna = Common_ComboDicID("cboSenAna","LABTestRstSen");
        
		// 控件赋值
		if (d){
			obj.AntiUseID = d.AntiUseID;
			$('#cboAnti').lookup('setText',d.AntiDesc);
			$('#txtDoseQty').val(d.DoseQty);
			$('#cboDoseUnit').combobox('setValue',d.DoseUnitID);
			$('#cboDoseUnit').combobox('setText',d.DoseUnit);
			$('#cboPhcFreq').combobox('setValue',d.PhcFreqID);
			$('#cboPhcFreq').combobox('setText',d.PhcFreq);
			$('#cboMedUsePurpose').combobox('setValue',d.MedUsePurposeID);
			$('#cboMedUsePurpose').combobox('setText',d.MedUsePurpose);
			$('#cboAdminRoute').combobox('setValue',d.AdminRouteID);
			$('#cboAdminRoute').combobox('setText',d.AdminRoute);
			$('#cboMedPurpose').combobox('setValue',d.MedPurposeID);
			$('#cboMedPurpose').combobox('setText',d.MedPurpose);
			$('#cboTreatmentMode').combobox('setValue',d.TreatmentModeID);
			$('#cboTreatmentMode').combobox('setText',d.TreatmentMode);
			$('#cboPreMedEffect').combobox('setValue',d.PreMedEffectID);
			$('#cboPreMedEffect').combobox('setText',d.PreMedEffect);
			$('#cboPreMedIndicat').combobox('setValue',d.PreMedIndicatID);
			$('#cboPreMedIndicat').combobox('setText',d.PreMedIndicat);
			$('#cboCombinedMed').combobox('setValue',d.CombinedMedID);
			$('#cboCombinedMed').combobox('setText',d.CombinedMed);
			$('#cboSenAna').combobox('setValue',d.SenAnaID);
			$('#cboSenAna').combobox('setText',d.SenAna);
			$('#txtPreMedTime').val(d.PreMedTime);
			$('#txtPostMedDays').val(d.PostMedDays);
			$('#txtSttDate').datebox('setValue',d.SttDate);
			$('#txtEndDate').datebox('setValue',d.EndDate);

		}else {
			$('#cboAnti').lookup('setText','');
			$('#txtDoseQty').val('');
			$('#cboDoseUnit').combobox('clear');
			$('#cboPhcFreq').combobox('clear');
			$('#cboMedUsePurpose').combobox('clear');
			$('#cboAdminRoute').combobox('clear');
			$('#cboMedPurpose').combobox('clear');
			$('#cboTreatmentMode').combobox('clear');
			$('#cboPreMedEffect').combobox('clear');
			$('#cboPreMedIndicat').combobox('clear');
			$('#cboCombinedMed').combobox('clear');
			$('#cboSenAna').combobox('clear');
			$('#txtPreMedTime').val('');
			$('#txtPostMedDays').val('');
			$('#txtSttDate').datebox('clear');
			$('#txtEndDate').datebox('clear');
		}
	}

	// 添加抗菌用药信息到列表
	function INFAntiAdd(d,r){
		var NowDate = Common_GetDate(new Date()); 

		var ID = '';
		var AntiUseID = obj.AntiUseID;
		var AntiDesc2 = '';
		if (d){
			ID = d.ID;
			AntiUseID = d.AntiUseID;
			AntiDesc2 = d.AntiDesc2;
		}
		var AntiDesc = $('#cboAnti').lookup('getText');
		var DoseQty = $('#txtDoseQty').val();
		var DoseUnitID = $('#cboDoseUnit').combobox('getValue');
		if (DoseUnitID==''){
			var DoseUnit='';
		}else{
			var DoseUnit = $('#cboDoseUnit').combobox('getText');
		}
		var PhcFreqID = $('#cboPhcFreq').combobox('getValue');
		if (PhcFreqID==''){
			var PhcFreq='';
		}else{
			var PhcFreq = $('#cboPhcFreq').combobox('getText');
		}
		var MedUsePurposeID = $('#cboMedUsePurpose').combobox('getValue');
		if (MedUsePurposeID==''){
			var MedUsePurpose='';
		}else{
			var MedUsePurpose = $('#cboMedUsePurpose').combobox('getText');
		}
		var AdminRouteID = $('#cboAdminRoute').combobox('getValue');
		if (AdminRouteID==''){
			var AdminRoute='';
		}else{
			var AdminRoute = $('#cboAdminRoute').combobox('getText');
		}
		var MedPurposeID = $('#cboMedPurpose').combobox('getValue');
		if (MedPurposeID==''){
			var MedPurpose='';
		}else{
			var MedPurpose = $('#cboMedPurpose').combobox('getText');
		}
		var TreatmentModeID = $('#cboTreatmentMode').combobox('getValue');
		if (TreatmentModeID==''){
			var TreatmentMode='';
		}else{
			var TreatmentMode = $('#cboTreatmentMode').combobox('getText');
		}	
		var PreMedEffectID = $('#cboPreMedEffect').combobox('getValue');
		if (PreMedEffectID==''){
			var PreMedEffect='';
		}else{
			var PreMedEffect = $('#cboPreMedEffect').combobox('getText');
		}	
		var PreMedIndicatID = $('#cboPreMedIndicat').combobox('getValue');
		if (PreMedIndicatID==''){
			var PreMedIndicat='';
		}else{
			var PreMedIndicat = $('#cboPreMedIndicat').combobox('getText');
		}
		var CombinedMedID = $('#cboCombinedMed').combobox('getValue');
		if (CombinedMedID==''){
			var CombinedMed='';
		}else{
			var CombinedMed = $('#cboCombinedMed').combobox('getText');
		}
		var SttDate = $('#txtSttDate').datebox('getValue');
		var EndDate = $('#txtEndDate').datebox('getValue');
		var PreMedTime = $('#txtPreMedTime').val();
		var PostMedDays = $('#txtPostMedDays').val();
		var SenAnaID = $('#cboSenAna').combobox('getValue');
		if (SenAnaID==''){
			var SenAna='';
		}else{
			var SenAna = $('#cboSenAna').combobox('getText');
		}
	
		var errinfo = "";
    	if (obj.AntiUseID==''){
			errinfo = errinfo + "请选择标准抗菌用药医嘱!<br>";
    	}
    	if (DoseQty==''){
    		errinfo = errinfo + "剂量不能为空!<br>";
    	}
    	if (DoseUnitID==''){
			errinfo = errinfo + "剂量单位为空或字典未对照!<br>";
    	}
    	if (PhcFreqID==''){
			errinfo = errinfo + "频次为空或字典未对照!<br>";
    	}
		if (AdminRouteID==''){
    		errinfo = errinfo + "给药途径为空或字典未对照!<br>";
    	}
    	if (MedPurposeID==''){
			errinfo = errinfo + "目的为空或字典未对照!<br>";
    	}else {
	    	if (MedPurpose=="预防") {
		    	if (PreMedEffectID==''){
		    		errinfo = errinfo + "目的为预防时,预防用药效果不能为空!<br>";
		    	}
		    	if (PreMedIndicatID==''){
		    		errinfo = errinfo + "目的为预防时,预防用药指征不能为空!<br>";
		    	}
	    	}
	    	if ((MedPurpose.indexOf("预防")>=0)&&(MedPurpose.indexOf("治疗")>=0))  {
		    	if (TreatmentModeID==''){
					errinfo = errinfo + "目的为治疗+预防时,治疗用药方式不能为空!<br>";
	    		}
		    	if (PreMedEffectID==''){
		    		errinfo = errinfo + "目的为治疗+预防时,预防用药效果不能为空!<br>";
		    	}
		    	if (PreMedIndicatID==''){
		    		errinfo = errinfo + "目的为治疗+预防时,预防用药指征不能为空!<br>";
		    	}
	    	}
		    	
	    	if (MedPurpose=="治疗")  {
		    	if (TreatmentModeID==''){
					errinfo = errinfo + "目的为治疗时,治疗用药方式不能为空!<br>";
	    		}
	    	}
    	}

		if (CombinedMedID==''){
			errinfo = errinfo + "联合用药不能为空!<br>";
    	}
		if (SttDate==''){
			errinfo = errinfo + "开始日期不能为空!<br>";
    	}
		if (Common_CompareDate(SttDate,NowDate)>0) {
    		errinfo = errinfo + "开始时间不能在当前时间之后!<br>"; 
    	}
    	if(EndDate!=''){
			if (Common_CompareDate(SttDate,EndDate)>0){
				errinfo = errinfo + "结束日期不能在开始日期之前!<br>"; 
			}
		}
		
		if (errinfo !='') {
			$.messager.alert("提示", errinfo, 'info');
			return ;
		}
    
		var row ={
			ID:ID,
			EpisodeID:EpisodeID,
			ReportID:ReportID,
			AntiUseID:AntiUseID,
			AntiDesc:AntiDesc,
			AntiDesc2:AntiDesc2,
			SttDate:SttDate,
			EndDate:EndDate,
			DoseQty:DoseQty,
			DoseUnitID:DoseUnitID,
			DoseUnit:DoseUnit,
			PhcFreqID:PhcFreqID,
			PhcFreq:PhcFreq,
			MedUsePurposeID:MedUsePurposeID,
			MedUsePurpose:MedUsePurpose,
			AdminRouteID:AdminRouteID,
			AdminRoute:AdminRoute,
			MedPurposeID:MedPurposeID,
			MedPurpose:MedPurpose,
			TreatmentModeID:TreatmentModeID,
			TreatmentMode:TreatmentMode,
			PreMedEffectID:PreMedEffectID,
			PreMedEffect:PreMedEffect,
			PreMedIndicatID:PreMedIndicatID,
			PreMedIndicat:PreMedIndicat,
			CombinedMedID:CombinedMedID,
			CombinedMed:CombinedMed,
			PreMedTime:PreMedTime,
			PostMedDays:PostMedDays,
			SenAnaID:SenAnaID,
			SenAna:SenAna,
			UpdateDate:'',
			UpdateTime:'',
			UpdateUserID:$.LOGON.USERID,
			UpdateUser:''
		}
	
		// 数据重复标志
    	var dataRepeatFlg = 0;
    	for (var i=0;i<obj.gridINFAnti.getRows().length;i++){
    		//r 为行号
			if ((parseInt(r) >-1)&&(r==i)) {	
				continue;	
			}
		
    		if ((AntiDesc==obj.gridINFAnti.getRows()[i].AntiDesc)&&(SttDate==obj.gridINFAnti.getRows()[i].SttDate)){
    			dataRepeatFlg = 1;
    		}
    	}
    	if (dataRepeatFlg == 1) {
			$.messager.confirm("提示", "存在开始日期、抗生素相同的记录,是否添加抗生素信息？", function (t) {
				if (t){	
					if (parseInt(r) >-1){  //修改
						obj.gridINFAnti.updateRow({  //更新指定行
							index: r,	   // index：要插入的行索引，如果该索引值未定义，则追加新行。row：行数据。
							row:row
						});
					}else{	//添加
						obj.gridINFAnti.appendRow({  //插入一个新行
							ID:ID,
							EpisodeID:EpisodeID,
							ReportID:ReportID,
							AntiUseID:AntiUseID,
							AntiDesc:AntiDesc,
							AntiDesc2:AntiDesc2,
							SttDate:SttDate,
							EndDate:EndDate,
							DoseQty:DoseQty,
							DoseUnitID:DoseUnitID,
							DoseUnit:DoseUnit,
							PhcFreqID:PhcFreqID,
							PhcFreq:PhcFreq,
							MedUsePurposeID:MedUsePurposeID,
							MedUsePurpose:MedUsePurpose,
							AdminRouteID:AdminRouteID,
							AdminRoute:AdminRoute,
							MedPurposeID:MedPurposeID,
							MedPurpose:MedPurpose,
							TreatmentModeID:TreatmentModeID,
							TreatmentMode:TreatmentMode,
							PreMedEffectID:PreMedEffectID,
							PreMedEffect:PreMedEffect,
							PreMedIndicatID:PreMedIndicatID,
							PreMedIndicat:PreMedIndicat,
							CombinedMedID:CombinedMedID,
							CombinedMed:CombinedMed,
							PreMedTime:PreMedTime,
							PostMedDays:PostMedDays,
							SenAnaID:SenAnaID,
							SenAna:SenAna,
							UpdateDate:'',
							UpdateTime:'',
							UpdateUserID:$.LOGON.USERID,
							UpdateUser:''
						});
					}
					$HUI.dialog('#LayerOpenINFAntiEdit').close();
				}				
			});
    	}else{
			if (parseInt(r) >-1){  //修改
				obj.gridINFAnti.updateRow({  //更新指定行
					index: r,	   // index：要插入的行索引，如果该索引值未定义，则追加新行。row：行数据。
					row:row
				});
			}else{	//添加
				obj.gridINFAnti.appendRow({  //插入一个新行
					ID:ID,
					EpisodeID:EpisodeID,
					ReportID:ReportID,
					AntiUseID:AntiUseID,
					AntiDesc:AntiDesc,
					AntiDesc2:AntiDesc2,
					SttDate:SttDate,
					EndDate:EndDate,
					DoseQty:DoseQty,
					DoseUnitID:DoseUnitID,
					DoseUnit:DoseUnit,
					PhcFreqID:PhcFreqID,
					PhcFreq:PhcFreq,
					MedUsePurposeID:MedUsePurposeID,
					MedUsePurpose:MedUsePurpose,
					AdminRouteID:AdminRouteID,
					AdminRoute:AdminRoute,
					MedPurposeID:MedPurposeID,
					MedPurpose:MedPurpose,
					TreatmentModeID:TreatmentModeID,
					TreatmentMode:TreatmentMode,
					PreMedEffectID:PreMedEffectID,
					PreMedEffect:PreMedEffect,
					PreMedIndicatID:PreMedIndicatID,
					PreMedIndicat:PreMedIndicat,
					CombinedMedID:CombinedMedID,
					CombinedMed:CombinedMed,
					PreMedTime:PreMedTime,
					PostMedDays:PostMedDays,
					SenAnaID:SenAnaID,
					SenAna:SenAna,
					UpdateDate:'',
					UpdateTime:'',
					UpdateUserID:$.LOGON.USERID,
					UpdateUser:''
				});
			}
			$HUI.dialog('#LayerOpenINFAntiEdit').close();
    	};
	}
     
	// 删除抗菌用药信息事件
	$("#btnINFAntiDel").click(function(e){
		var selectObj = obj.gridINFAnti.getSelected();
		var index = obj.gridINFAnti.getRowIndex(selectObj);  //获取当前选中行的行号(从0开始)
		if (!selectObj) {
			$.messager.alert("提示", "请选择一行要删除的抗菌用药数据!", 'info');
			return;
		}else {
			$.messager.confirm("提示", "是否要删除抗菌用药："+selectObj.AntiDesc+" ?", function (r) {
				if (r){				
					obj.gridINFAnti.deleteRow(index);
				}
			});
		}				
	});
	
	obj.ANT_Save = function(){
		// 抗菌用药
    	var InputAnti = '';
    	for (var i=0;i<obj.gridINFAnti.getRows().length;i++){
    		var Input = obj.gridINFAnti.getRows()[i].ID;
    		Input = Input + CHR_1 + obj.gridINFAnti.getRows()[i].EpisodeID;
    		Input = Input + CHR_1 + obj.gridINFAnti.getRows()[i].AntiUseID;
    		Input = Input + CHR_1 + obj.gridINFAnti.getRows()[i].AntiDesc;
    		Input = Input + CHR_1 + obj.gridINFAnti.getRows()[i].AntiDesc2;
    		Input = Input + CHR_1 + obj.gridINFAnti.getRows()[i].SttDate;
    		Input = Input + CHR_1 + obj.gridINFAnti.getRows()[i].EndDate;
    		Input = Input + CHR_1 + obj.gridINFAnti.getRows()[i].DoseQty;
    		Input = Input + CHR_1 + obj.gridINFAnti.getRows()[i].DoseUnitID;
    		Input = Input + CHR_1 + obj.gridINFAnti.getRows()[i].PhcFreqID;
    		Input = Input + CHR_1 + obj.gridINFAnti.getRows()[i].MedUsePurposeID;
    		Input = Input + CHR_1 + obj.gridINFAnti.getRows()[i].AdminRouteID;
    		Input = Input + CHR_1 + obj.gridINFAnti.getRows()[i].MedPurposeID;
    		Input = Input + CHR_1 + obj.gridINFAnti.getRows()[i].TreatmentModeID;
    		Input = Input + CHR_1 + obj.gridINFAnti.getRows()[i].PreMedEffectID;
    		Input = Input + CHR_1 + obj.gridINFAnti.getRows()[i].PreMedIndicatID;
    		Input = Input + CHR_1 + obj.gridINFAnti.getRows()[i].CombinedMedID;
    		Input = Input + CHR_1 + obj.gridINFAnti.getRows()[i].PreMedTime;
    		Input = Input + CHR_1 + obj.gridINFAnti.getRows()[i].PostMedDays;
    		Input = Input + CHR_1 + obj.gridINFAnti.getRows()[i].SenAnaID;
    		Input = Input + CHR_1 + '';
    		Input = Input + CHR_1 + '';
    		Input = Input + CHR_1 + $.LOGON.USERID;
    		InputAnti = InputAnti + CHR_2 + Input;
    	}
    	if (InputAnti) InputAnti = InputAnti.substring(1,InputAnti.length);
    	return InputAnti;
	}

}