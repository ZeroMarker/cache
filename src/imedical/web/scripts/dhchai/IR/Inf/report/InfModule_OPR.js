function InitOper(obj){
	// 手术信息
	obj.refreshgridINFOPS = function(){
		if(obj.gridINFOPS==undefined)
		{
			obj.gridINFOPS = $("#gridINFOPS").DataTable({
				dom: 'rt',
				paging:false,
				select: 'single',
				ordering: false,
				ajax: {
					"url": "dhchai.query.datatables.csp",
					"data": function (d) {
						d.ClassName = "DHCHAI.IRS.INFOPSSrv";
						d.QueryName = "QryINFOPSByRep";
						d.Arg1 = ReportID;
						d.Arg2 = '';
						d.Arg3 = 0;
						d.ArgCnt = 3;
					}
				},
				columns: [
					{"data": "OperName"}
					,{"data": "OperType"}
					,{"data": "OperLoc"}
					,{	
						"data": null,
						render: function ( data, type, row ) {
							var OperDateTime = data.OperDate+' '+data.SttTime
							return OperDateTime;
						}
					},{	
						"data": null,
						render: function ( data, type, row ) {
							var OperDateTime = data.EndDate+' '+data.EndTime
							return OperDateTime;
						}
					}
					,{"data": "OperDocTxt"}
					,{"data": "Anesthesia"}
					,{"data": "CuteType"}
					,{"data": "NNISLevel"}
					,{"data": "CuteHealing"}
					,{"data": "IsOperInf", 
						render: function ( data, type, row ) {
							if (data=="1"){
								return '是';
							}else{
								return '否'
							}
						}
					}
					,{"data": "InfType"}
					,{"data": "IsInHospInf", 
						render: function ( data, type, row ) {
							if (data=="1"){
								return '是';
							}else{
								return '否'
							}
						}
					}
				]
			});
		}else{
			obj.gridINFOPS.ajax.reload(function(){});
		}
	}
	obj.refreshgridINFOPS();

	var IsHist = 0;
	function refreshgridINFOPSSync() {
		if(obj.gridINFOPSSync==undefined)
		{
		    obj.gridINFOPSSync = $("#gridINFOPSSync").DataTable({
		        dom: 'rt',
		        paging:false,
		        select: 'single',
		        ordering: false,
		        ajax: {
		            "url": "dhchai.query.datatables.csp",
		            "data": function (d) {
		                d.ClassName = "DHCHAI.IRS.INFOPSSrv";
		                d.QueryName = "QryINFOPSByRep";
		                d.Arg1 = '';
		                d.Arg2 = EpisodeID;
		                d.Arg3 = IsHist;
						d.ArgCnt = 3;
					}
				},
				columns: [
					{"data": "OperName"}
					,{"data": "OperType"}
					,{"data": "OperLoc"}
					,{	
						"data": null,
						render: function ( data, type, row ) {
							var OperDateTime = data.OperDate+' '+data.SttTime
							return OperDateTime;
						}
					},{	
						"data": null,
						render: function ( data, type, row ) {
							var OperDateTime = data.EndDate+' '+data.EndTime
							return OperDateTime;
						}
					}
					,{"data": "OperDocTxt"}
					,{"data": "Anesthesia"}
					,{"data": "CuteType"}
					,{"data": "CuteHealing"}
					,{"data": "NNISLevel"}
				]
			});
			obj.gridINFOPSSync.on('dblclick', 'tr', function(e) {
				var data  = obj.gridINFOPSSync.row(this).data();
				if (typeof(data)=='undefined') return;
				layer.closeAll();
				OpenINFOPSEdit(data,'');
			});
		}else{
			obj.gridINFOPSSync.ajax.reload(function(){});
		}
	}

	// 弹出手术信息提取框
	function OpenINFOPSSync() {
	    IsHist = 0;
	    $("#MoreOPR").css({ 'background-color': 'white' });
	    $("#OPRInfo").css({ 'background-color': '#8dd3e4' });
		refreshgridINFOPSSync();
		obj.LayerOpenINFOPSSync = layer.open({
				type: 1,
				zIndex: 100,
				maxmin: false,
				title: "手术信息-提取<span class='text-red'>[双击数据进行编辑]<span>", 
				area: '75%',
				content: $('#LayerOpenINFOPSSync')
		});
        //点击手术查询当次信息
		$("#MoreOPR").on('click', function () {
		    $("#MoreOPR").css({ 'background-color': '#8dd3e4' });
		    $("#OPRInfo").css({ 'background-color': 'white' });
		    IsHist = 1;
		    refreshgridINFOPSSync();
		});
	    //点击更多手术查询往次信息
		$("#OPRInfo").on('click', function () {
		    $("#MoreOPR").css({ 'background-color': 'white' });
		    $("#OPRInfo").css({ 'background-color': '#8dd3e4' });
		    IsHist = 0;
		    refreshgridINFOPSSync();
		});
	}
	
	// 弹出手术信息弹框
	function OpenINFOPSEdit(d,r){
		$("#cboInfType").attr('disabled','disabled');
	    $('#chkIsOperInf + .iCheck-helper').click(function(){
		    $.form.SetValue("cboInfType","","");
			if ($("#chkIsOperInf").parent().hasClass("checked")){
				$("#cboInfType").removeAttr("disabled");
			}else {
				$("#cboInfType").attr('disabled','disabled');
			}
		});
		obj.LayerOpenINFOPSEdit = layer.open({
				type: 1,
				zIndex: 100,
				maxmin: false,
				title: "手术信息-编辑", 
				area: ['700px',''],
				content: $('#LayerOpenINFOPSEdit'),
				btnAlign: 'c',
				btn: ['保存','取消'],
				yes: function(index, layero){
				  	// 添加数据
					INFOPSAdd(d,r);
				}
				,success: function(layero){
					InitINFOPSEditData(d);
				}
		});	
	}

	// 添加手术信息到列表
	function INFOPSAdd(d,r){
		var OperTypeID = $.form.GetValue("cboOperType");
		if (OperTypeID==''){
			var OperType='';
		}else{
			var OperType = $.form.GetText("cboOperType");
		}
		var OperName = $.form.GetText("cboOper");
		var OperLocID = $.form.GetValue("cboOperLoc");
		if (OperLocID==''){
			var OperLoc = '';
		}else{
			var OperLoc = $.form.GetText("cboOperLoc");
		}
		var SttDateTime = $.form.GetValue("txtOperSttDateTime");
		var OperDate = SttDateTime.split(' ')[0];
		var SttTime = SttDateTime.split(' ')[1];
		var EndDateTime = $.form.GetValue("txtOperEndDateTime");
		var EndDate = EndDateTime.split(' ')[0];
		var EndTime = EndDateTime.split(' ')[1];
		var OperDocTxt = $.form.GetText("cboOperDoctor");
		var OperDoc = $.form.GetText("cboOperDoctor");
		var OperDocID = $.form.GetValue("cboOperDoctor");
		if (OperDocID=='-1') OperDocID = '';
		var AnesthesiaID = $.form.GetValue("cboAnesMethod");
		if (AnesthesiaID==''){
			var Anesthesia = '';
		}else{
			var Anesthesia = $.form.GetText("cboAnesMethod");
		}
		var CuteTypeID = $.form.GetValue("cboIncisionr");
		if (CuteTypeID==''){
			var CuteType = '';
		}else{
			var CuteType = $.form.GetText("cboIncisionr");
		}
		var NNISLevelID = $.form.GetValue("cboNNISLevel");
		if (NNISLevelID==''){
			var NNISLevel = '';
		}else{
			var NNISLevel = $.form.GetText("cboNNISLevel");
		}
		var CuteHealingID = $.form.GetValue("cboHealing");
		if (CuteHealingID==''){
			var CuteHealing = '';
		}else{
			var CuteHealing = $.form.GetText("cboHealing");
		}
		var IsOperInf = 0;
   		if($("#chkIsOperInf").is(':checked')){
        	IsOperInf = 1;
   		}
   		var InfTypeID = $.form.GetValue("cboInfType");
   		if (InfTypeID==''){
			var InfType = '';
		}else{
			var InfType = $.form.GetText("cboInfType");
		}
   		var IsInHospInf = 0;
   		if($("#chkIsInHospInf").is(':checked')){
        	IsInHospInf = 1;
   		}
		var ImplantFlag = 0;
   		if($("#chkImplants").is(':checked')){
        	ImplantFlag = 1;
   		}
   		if (OperTypeID==''){
    		layer.msg('手术类型不能为空!',{icon: 2});
			return;
    	}
    	if (OperName==''){
    		layer.msg('手术名称不能为空!',{icon: 2});
			return;
    	}
    	if (OperLocID==''){
    		layer.msg('手术科室不能为空!',{icon: 2});
			return;
    	}
    	if (SttDateTime==''){
    		layer.msg('开始时间不能为空!',{icon: 2});
			return;
    	}
    	if (EndDateTime==''){
    		layer.msg('结束时间不能为空!',{icon: 2});
			return;
    	}
    	if (!obj.checkDate(SttDateTime)) {
			layer.msg('手术开始日期必须处于住院期间!',{icon: 2});
			return;
		}
    	if (!obj.checkDate(EndDateTime)) {
    	    layer.msg('手术结束日期必须处于住院期间!', { icon: 2 });
			return;
		}
		if (obj.checkNowDate(OperDate,SttTime)){
			layer.msg('开始时间不能大于当前时间',{icon: 2});
			return;
		}
		if (obj.checkNowDate(EndDate,EndTime)){
			layer.msg('结束时间不能大于当前时间',{icon: 2});
			return;
		}
		if (SttDateTime>EndDateTime) {
		    layer.msg('手术开始时间不能大于手术结束时间', { icon: 2 });
		    return;
		}
    	if (OperDocTxt==''){
    		layer.msg('手术医生不能为空!',{icon: 2});
			return;
    	}
    	if (AnesthesiaID==''){
    		layer.msg('麻醉方式不能为空!',{icon: 2});
			return;
    	}
    	if (NNISLevelID==''){
    		layer.msg('NNIS分级不能为空!',{icon: 2});
			return;
    	}
    	if (CuteTypeID==''){
    		layer.msg('切口类型不能为空!',{icon: 2});
			return;
    	}
    	if ((IsOperInf==1)&&(InfTypeID=='')){
    		layer.msg('感染类型不能为空!',{icon: 2});
			return;
    	}
    	var ID ='';
    	var OperAnaesID=''
    	if (d){
    		ID = d.ID;
    		OperAnaesID = d.OperAnaesID;
    	}
    	// 手麻记录ID特殊处理
		if (OperAnaesID=='-1') OperAnaesID = '';
		var row ={
			'ID':ID,
			'EpisodeID':EpisodeID,
			'ReportID':ReportID,
			'OperAnaesID':OperAnaesID,
			'OperName':OperName,
			'OperName2':'',
			'OperLocID':OperLocID,
			'OperLoc':OperLoc,
			'OperDate':OperDate,
			'EndDate':EndDate,
			'SttTime':SttTime,
			'EndTime':EndTime,
			'OperHours':'',
			'OperDocTxt':OperDocTxt,
			'OperDocID':OperDocID,
			'OperDoc':OperDoc,
			'OperTypeID':OperTypeID,
			'OperType':OperType,
			'AnesthesiaID':AnesthesiaID,
			'Anesthesia':Anesthesia,
			'NNISLevelID':NNISLevelID,
			'NNISLevel':NNISLevel,
			'CuteTypeID':CuteTypeID,
			'CuteType':CuteType,
			'CuteHealingID':CuteHealingID,
			'CuteHealing':CuteHealing,
			'IsOperInf':IsOperInf,
			'InfTypeID':InfTypeID,
			'InfType':InfType,
			'IsInHospInf':IsInHospInf,
			'ASAScoreID':'',
			'ASAScore':'',
			'PreoperWBC':'',
			'CuteNumber':'',
			'EndoscopeFlag':'',
			'ImplantFlag':ImplantFlag,
			'PreoperAntiFlag':'',
			'BloodLossFlag':'',
			'BloodLoss':'',
			'BloodTransFlag':'',
			'BloodTrans':'',
			'PostoperComps':'',
			'UpdateDate':'',
			'UpdateTime':'',
			'UpdateUserID':$.LOGON.USERID,
			'UpdateUser':''
		}
		// 数据重复标志
    	var dataRepeatFlg = 0;
    	for (var i=0;i<obj.gridINFOPS.data().length;i++){
    		if (r) {
    			if ($(r).context._DT_RowIndex==i){
    				continue;
    			}
    		}
			if ((OperAnaesID!="")&&(OperAnaesID==obj.gridINFOPS.data()[i].OperAnaesID)) {
				layer.msg('同一条手术记录只允许提取添加一次,如需修改请选择已添加的手术记录!',{icon: 2});
				return;
			}
    		if ((OperName==obj.gridINFOPS.data()[i].OperName)&&(OperDate==obj.gridINFOPS.data()[i].OperDate)){
    			dataRepeatFlg = 1;
    		}
    	}
    	if (dataRepeatFlg == 1) {
    		layer.confirm('存在手术日期、手术名称相同的记录,是否添加手术信息？', {
			  btn: ['是','否'] //按钮
			}, function(){
				InsertOps(r,row);
			});
    	}else{
    		InsertOps(r,row);
    	};
	}

	function InsertOps(r,row){
		if (r){  //修改
			obj.gridINFOPS.row(r).data(row).draw();
		}else{	//添加
			obj.gridINFOPS.row.add(row).draw();
		}
		layer.closeAll();
	}

	// 手术编辑框信息初始化
	function InitINFOPSEditData(d){
		// 渲染控件
		$.form.SelectRender('cboOperType');
		$.form.SelectRender1('cboOper',2);		//手术
		$("#cboOperLoc").attr("data-param",$.LOGON.HOSPID+"^Arg^I^E")			//设置科室参数
		$.form.SelectRender1('cboOperLoc',1);
		// 手术医生
		var UseTypeID = $.Tool.RunServerMethod('DHCHAI.BTS.DictionarySrv','GetIDByCode','UserType','D',1);
		$("#cboOperDoctor").attr("data-param","^"+UseTypeID+"^Arg^^1");
		$.form.SelectRender1('cboOperDoctor',1);
		$.form.SelectRender('cboAnesMethod');
		$.form.SelectRender('cboIncisionr');
		$.form.SelectRender('cboHealing');
		$.form.SelectRender('cboNNISLevel');
		$.form.SelectRender('cboInfType');
		$.form.DateTimeRender1('txtOperSttDateTime','');
		$.form.DateTimeRender1('txtOperEndDateTime','');
		$("#chkIsOperInf").iCheck('uncheck');
		$("#chkIsInHospInf").iCheck('uncheck');
		$("#chkImplants").iCheck('uncheck');
		// 控件赋值
		if (d){
			$.form.SetValue('cboOperType',d.OperTypeID,d.OperType);
			$.form.SetValue('cboAnesMethod',d.AnesthesiaID,d.Anesthesia);
			$.form.SetValue('cboIncisionr',d.CuteTypeID,d.CuteType);
			$.form.SetValue('cboNNISLevel',d.NNISLevelID,d.NNISLevel);
			$.form.SetValue('cboHealing',d.CuteHealingID,d.CuteHealing);
			$.form.SetValue('cboInfType',d.InfTypeID,d.InfType);
			$.form.DateTimeRender1('txtOperSttDateTime',d.OperDate+' '+d.SttTime);
			if ((d.EndDate!='')&&(d.EndTime!='')){
				$.form.DateTimeRender1('txtOperEndDateTime',d.EndDate+' '+d.EndTime);
			}else{
				$.form.DateTimeRender1('txtOperEndDateTime','');
			}
			$("#cboOper").append(new Option(d.OperName, '-1', false, true));

			var OperLocID = d.OperLocID;
			if ((d.OperLocID=='')||(d.OperLocID=='-1')){
				OperLocID = -1;
			}
			var OperDocID = d.OperDocID;
			if ((d.OperDocID=='')||(d.OperDocID=='-1')){
				OperDocID = -1;
			}
			$("#cboOperLoc").append(new Option(d.OperLoc,OperLocID, false, true));
			$("#cboOperDoctor").append(new Option( d.OperDocTxt,OperDocID, false, true));
		
			if (d.IsOperInf==1){
				$("#chkIsOperInf").iCheck('check');
			}else{
				$("#chkIsOperInf").iCheck('uncheck');
			}
			if (d.IsInHospInf==1){
				$("#chkIsInHospInf").iCheck('check');
			}else{
				$("#chkIsInHospInf").iCheck('uncheck');
			}
			if (d.ImplantFlag==1){
				$("#chkImplants").iCheck('check');
			}else{
				$("#chkImplants").iCheck('uncheck');
			}
			
		}
	}

	// 删除手术信息事件
	$("#btnINFOPSDel").click(function(e){
		var selectedRows = obj.gridINFOPS.rows({selected: true}).count();
		if (selectedRows!== 1 ) {
			layer.msg('请选择一行数据!',{icon: 2});
			return;
		}else{
			var rd = obj.gridINFOPS.rows({selected: true}).data().toArray()[0];
			layer.confirm('是否删除手术信息：'+rd.OperName+'？', {
			  btn: ['是','否'] //按钮
			}, function(){
				obj.gridINFOPS.rows({selected:true}).remove().draw(false);
				layer.msg('删除手术信息成功！', {icon: 1});
			});
			// obj.gridINFOPS.rows({selected:true}).remove().draw(false);
		}
	});

	// 添加手术信息事件
	$("#btnINFOPSAdd").click(function(e){
		obj.OperAnaesID = '';
		OpenINFOPSEdit('','');
	});

	// 手术信息提取事件
	$('#btnINFOPSSync').click(function(e){
		/// TODO同步手术
		$.Tool.RunServerMethod('DHCHAI.DI.DHS.SyncOpsInfo','SyncOperByDateAdm',OPSSCode,EpisodeIDx,ServiceDate,ServiceDate);
		OpenINFOPSSync();
	});
	// 手术信息列表双击事件
	obj.gridINFOPS.on('dblclick', 'tr', function(e) {
		var data  = obj.gridINFOPS.row(this).data();
		if (typeof(data)=='undefined') return;
		OpenINFOPSEdit(data,this);
	});

	obj.OPR_Save = function(){
		// 手术信息
    	var OPS = '';
    	for (var i=0;i<obj.gridINFOPS.data().length;i++){
    		var Input = obj.gridINFOPS.data()[i].ID;
    		Input = Input + CHR_1 + obj.gridINFOPS.data()[i].EpisodeID;
    		Input = Input + CHR_1 + obj.gridINFOPS.data()[i].OperAnaesID;
    		Input = Input + CHR_1 + obj.gridINFOPS.data()[i].OperLocID;
    		Input = Input + CHR_1 + obj.gridINFOPS.data()[i].OperName;
    		Input = Input + CHR_1 + obj.gridINFOPS.data()[i].OperName2;
    		Input = Input + CHR_1 + obj.gridINFOPS.data()[i].OperDate;
    		Input = Input + CHR_1 + obj.gridINFOPS.data()[i].EndDate;
    		Input = Input + CHR_1 + obj.gridINFOPS.data()[i].SttTime;
    		Input = Input + CHR_1 + obj.gridINFOPS.data()[i].EndTime;
    		Input = Input + CHR_1 + obj.gridINFOPS.data()[i].OperHours;
    		Input = Input + CHR_1 + obj.gridINFOPS.data()[i].OperDocTxt;
    		Input = Input + CHR_1 + obj.gridINFOPS.data()[i].OperDocID;
    		Input = Input + CHR_1 + obj.gridINFOPS.data()[i].OperTypeID;
    		Input = Input + CHR_1 + obj.gridINFOPS.data()[i].AnesthesiaID;
    		Input = Input + CHR_1 + obj.gridINFOPS.data()[i].NNISLevelID;
    		Input = Input + CHR_1 + obj.gridINFOPS.data()[i].CuteTypeID;
    		Input = Input + CHR_1 + obj.gridINFOPS.data()[i].CuteHealingID;
    		Input = Input + CHR_1 + obj.gridINFOPS.data()[i].IsOperInf;
    		Input = Input + CHR_1 + obj.gridINFOPS.data()[i].InfTypeID;
    		Input = Input + CHR_1 + obj.gridINFOPS.data()[i].IsInHospInf;
    		Input = Input + CHR_1 + obj.gridINFOPS.data()[i].ASAScoreID;
    		Input = Input + CHR_1 + obj.gridINFOPS.data()[i].PreoperWBC;
    		Input = Input + CHR_1 + obj.gridINFOPS.data()[i].CuteNumber;
    		Input = Input + CHR_1 + obj.gridINFOPS.data()[i].EndoscopeFlag;
    		Input = Input + CHR_1 + obj.gridINFOPS.data()[i].ImplantFlag;
    		Input = Input + CHR_1 + obj.gridINFOPS.data()[i].PreoperAntiFlag;
    		Input = Input + CHR_1 + obj.gridINFOPS.data()[i].BloodLoss;
    		Input = Input + CHR_1 + obj.gridINFOPS.data()[i].BloodLossFlag;
    		Input = Input + CHR_1 + obj.gridINFOPS.data()[i].BloodTrans;
    		Input = Input + CHR_1 + obj.gridINFOPS.data()[i].BloodTransFlag;
    		Input = Input + CHR_1 + obj.gridINFOPS.data()[i].PostoperComps;
    		Input = Input + CHR_1 + '';
    		Input = Input + CHR_1 + '';
    		Input = Input + CHR_1 + $.LOGON.USERID;
    		OPS = OPS + CHR_2 + Input;
    	}
    	if (OPS) OPS = OPS.substring(1,OPS.length);
    	return OPS;
	}
}