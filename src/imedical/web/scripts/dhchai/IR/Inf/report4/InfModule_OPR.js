function InitOper(obj){
	obj.INFOPSRows = "";  //通过 ReportID 取手术单条对象
	obj.INFOPSSyncRows = "";
	if(ReportID !="")
	{
		var runQuery = $.Tool.RunQuery('DHCHAI.IRS.INFOPSSrv','QryINFOPSByRep',ReportID,"");		
		var arrResult = runQuery.record;
		
		if(arrResult.length>0)
		{
			obj.INFOPSRows = arrResult[0];
		}
	}
	else if(OperAnaesID !="")
	{
		//显示特定手术记录
		var runQuery = $.Tool.RunQuery('DHCHAI.IRS.INFOPSSrv','QryINFOPSByRep',"",EpisodeID);		
		var arrResult = runQuery.record;
		if(arrResult.length>0)
		{
			obj.INFOPSSyncRows = arrResult[0];
		}
		for(var i=0;i<arrResult.length;i++)
		{
			var tmp = arrResult[i];
			if(tmp.OperAnaesID==OperAnaesID)
			{
				obj.INFOPSSyncRows = tmp;
			}
		}
	}
	InitINFOPSEditData();
	// 手术信息	
	function refreshgridINFOPSSync(){
		
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
						d.ArgCnt = 2;
					}
				},
				columns: [
					{"data": "OperType"}
					,{"data": "OperName"}
					,{"data": "OperLoc"}
					,{"data": "OperDate"}
					,{"data": "SttTime"}
					,{"data": "EndTime"}
					,{"data": "OperDocTxt"}
					,{"data": "Anesthesia"}
					,{"data": "CuteType"}
					,{"data": "CuteHealing"}
				]
			});
			obj.gridINFOPSSync.on('dblclick', 'tr', function(e) {
				var selectedRows = obj.gridINFOPSSync.rows({selected: true}).count();
				if ( selectedRows !== 1 ) return;
				layer.closeAll();
				OpenINFOPSEdit(this);
			});
		}else{
			obj.gridINFOPSSync.ajax.reload(function(){});
		}
	}

	// 弹出手术信息提取框
	function OpenINFOPSSync(){
		refreshgridINFOPSSync();
		obj.LayerOpenINFOPSSync = layer.open({
				type: 1,
				zIndex: 100,
				maxmin: false,
				title: "手术信息-提取[双击数据进行编辑]", 
				area: ['1200px','500px'],
				content: $('#LayerOpenINFOPSSync')
		});	
	}

	// 弹出手术信息弹框
	function OpenINFOPSEdit(INFOPSSyncRows){		
		obj.INFOPSSyncRows= obj.gridINFOPSSync.row(INFOPSSyncRows).data();
		//赋值选中数据
		InitINFOPSEditData();	
	}

	// 添加手术信息到列表
	function INFOPSAdd(){
		var INFOPSSyncRows = obj.INFOPSSyncRows;
		var INFOPSRows = obj.INFOPSRows;
		var ID = '';
		var OperAnaesID = '';
		if ((INFOPSSyncRows!=undefined)&&(INFOPSSyncRows!='')){
			var rd = INFOPSSyncRows;
			ID = '';
			OperAnaesID = rd.OperAnaesID;
		}
		if ((INFOPSRows!=undefined)&&(INFOPSRows!='')){
			var rd = INFOPSRows;
			ID = rd.ID;
			OperAnaesID = rd.OperAnaesID;
		}
		if (OperAnaesID=='-1') OperAnaesID = '';
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
		var OperDate = SttDateTime.split(' - ')[0];
		var SttTime = SttDateTime.split(' - ')[1];
		var EndDateTime = $.form.GetValue("txtOperEndDateTime");
		var EndDate = EndDateTime.split(' - ')[0];
		var EndTime = EndDateTime.split(' - ')[1];
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
    	if (OperDocTxt==''){
    		layer.msg('手术医生不能为空!',{icon: 2});
			return;
    	}
    	if (AnesthesiaID==''){
    		layer.msg('麻醉方式不能为空!',{icon: 2});
			return;
    	}
    	if (CuteTypeID==''){
    		layer.msg('切口等级不能为空!',{icon: 2});
			return;
    	}
    	if ((IsOperInf==1)&&(InfTypeID=='')){
    		layer.msg('感染类型不能为空!',{icon: 2});
			return;
    	}
		obj.OPR_SaveRow ={
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
			'NNISLevelID':'',
			'NNISLevel':'',
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
			'ImplantFlag':'',
			'PreoperAntiFlag':'',
			'BloodLossFlag':'',
			'BloodLoss':'',
			'BloodTransFlag':'',
			'BloodTrans':'',
			'PostoperComps':'',
			'UpdateDate':'',
			'UpdateTime':'',
			',UpdateUserID':$.LOGON.USERID,
			'UpdateUser':''
		}	
		
	}

	// 手术编辑框信息初始化
	function InitINFOPSEditData(){		
		// 渲染控件
		$.form.SelectRender('cboOperType');
		$.form.SelectRender1('cboOper',2);		//手术
		$("#cboOperLoc").attr("data-param",$.LOGON.HOSPID+"^Arg^I^E")			//设置科室参数
		$.form.SelectRender1('cboOperLoc',1);
		$.form.SelectRender1('cboOperDoctor',1);
		$.form.SelectRender('cboAnesMethod');
		$.form.SelectRender('cboIncisionr');
		
		$.form.SelectRender('cboHealing');
		$.form.SelectRender('cboInfType');
		$.form.DateTimeRender1('txtOperSttDateTime','');
		$.form.DateTimeRender1('txtOperEndDateTime','');
		$("#chkIsOperInf").iCheck('uncheck');
		$("#chkIsInHospInf").iCheck('uncheck');
		//
	  	$.form.SelectRender("cboASAScore");
	  	$.form.SelectRender("cboNNISLevel");
		// 控件赋值
		var INFOPSSyncRows=obj.INFOPSSyncRows;
		var INFOPSRows = obj.INFOPSRows;
		var rd = '';
		if ((INFOPSSyncRows!=undefined)&&(INFOPSSyncRows!='')){
			rd = INFOPSSyncRows;
		}
		if ((INFOPSRows!=undefined)&&(INFOPSRows!='')){
			rd = INFOPSRows;
		}
		$("#cboIncisionr").on("select2:select", function (e) { 
			//获得选中的医院
			obj.SumNNIS();
		});
		$("#cboASAScore").on("select2:select", function (e) { 
			//获得选中的医院
			obj.SumNNIS();
		});
		if (rd!=''){
			$.form.SetValue('cboOperType',rd.OperTypeID,rd.OperType);
			$.form.SetValue('cboAnesMethod',rd.AnesthesiaID,rd.Anesthesia);
			$.form.SetValue('cboIncisionr',rd.CuteTypeID,rd.CuteType);
			$.form.SetValue('cboHealing',rd.CuteHealingID,rd.CuteHealing);
			$.form.SetValue('cboInfType',rd.InfTypeID,rd.InfType);
			$.form.DateTimeRender1('txtOperSttDateTime',rd.OperDate+' - '+rd.SttTime);
			$.form.DateTimeRender1('txtOperEndDateTime',rd.EndDate+' - '+rd.EndTime);
			$("#cboOper").append(new Option(rd.OperName, '-1', false, true));
			$("#cboOperLoc").append(new Option(rd.OperLoc, (rd.OperLocID>0?rd.OperLocID:-1), false, true));
			$("#cboOperDoctor").append(new Option( rd.OperDoc, (rd.OperDocID>0?rd.OperDocID:-1), false, true));
			if (rd.IsOperInf){
				$("#chkIsOperInf").iCheck('check');
			}else{
				$("#chkIsOperInf").iCheck('uncheck');
			}
			if (rd.IsInHospInf){
				$("#chkIsInHospInf").iCheck('check');
			}else{
				$("#chkIsInHospInf").iCheck('uncheck');
			}
		}
		
	}
	// 手术信息提取事件
	$('#btnINFOPSSync').click(function(e){
		/// TODO同步手术
		$.Tool.RunServerMethod('DHCHAI.DI.DHS.SyncOpsInfo','SyncOperByDateAdm','OPS01',EpisodeIDx,'','');
		OpenINFOPSSync();
	});

	obj.OPR_SaveData = function(){	
		INFOPSAdd();
		// 手术信息		
    	var OPS = '';
    	if ((obj.OPR_SaveRow!=undefined)&&(obj.OPR_SaveRow!='')){
			var Input = obj.OPR_SaveRow.ID;
			Input = Input + CHR_1 + obj.OPR_SaveRow.EpisodeID;
			Input = Input + CHR_1 + obj.OPR_SaveRow.OperAnaesID;
			Input = Input + CHR_1 + obj.OPR_SaveRow.OperLocID;
			Input = Input + CHR_1 + obj.OPR_SaveRow.OperName;
			Input = Input + CHR_1 + obj.OPR_SaveRow.OperName2;
			Input = Input + CHR_1 + obj.OPR_SaveRow.OperDate;
			Input = Input + CHR_1 + obj.OPR_SaveRow.EndDate;
			Input = Input + CHR_1 + obj.OPR_SaveRow.SttTime;
			Input = Input + CHR_1 + obj.OPR_SaveRow.EndTime;
			Input = Input + CHR_1 + obj.OPR_SaveRow.OperHours;
			Input = Input + CHR_1 + obj.OPR_SaveRow.OperDocTxt;
			Input = Input + CHR_1 + obj.OPR_SaveRow.OperDocID;
			Input = Input + CHR_1 + obj.OPR_SaveRow.OperTypeID;
			Input = Input + CHR_1 + obj.OPR_SaveRow.AnesthesiaID;
			Input = Input + CHR_1 + obj.OPR_SaveRow.NNISLevelID;
			Input = Input + CHR_1 + obj.OPR_SaveRow.CuteTypeID;
			Input = Input + CHR_1 + obj.OPR_SaveRow.CuteHealingID;
			Input = Input + CHR_1 + obj.OPR_SaveRow.IsOperInf;
			Input = Input + CHR_1 + obj.OPR_SaveRow.InfTypeID;
			Input = Input + CHR_1 + obj.OPR_SaveRow.IsInHospInf;
			Input = Input + CHR_1 + obj.OPR_SaveRow.ASAScoreID;
			Input = Input + CHR_1 + obj.OPR_SaveRow.PreoperWBC;
			Input = Input + CHR_1 + obj.OPR_SaveRow.CuteNumber;
			Input = Input + CHR_1 + obj.OPR_SaveRow.EndoscopeFlag;
			Input = Input + CHR_1 + obj.OPR_SaveRow.ImplantFlag;
			Input = Input + CHR_1 + obj.OPR_SaveRow.PreoperAntiFlag;
			Input = Input + CHR_1 + obj.OPR_SaveRow.BloodLoss;
			Input = Input + CHR_1 + obj.OPR_SaveRow.BloodLossFlag;
			Input = Input + CHR_1 + obj.OPR_SaveRow.BloodTrans;
			Input = Input + CHR_1 + obj.OPR_SaveRow.BloodTransFlag;
			Input = Input + CHR_1 + obj.OPR_SaveRow.PostoperComps;
			Input = Input + CHR_1 + '';
			Input = Input + CHR_1 + '';
			Input = Input + CHR_1 + $.LOGON.USERID;
			OPS = OPS + CHR_2 + Input;
    	}
    	if (OPS) OPS = OPS.substring(1,OPS.length);
    	return OPS;
	};
	obj.SumNNIS = function()
	{
		var SttDateTime = $.form.GetValue("txtOperSttDateTime");
		var OperDate = SttDateTime.split(' - ')[0];
		var SttTime = SttDateTime.split(' - ')[1];
		var EndDateTime = $.form.GetValue("txtOperEndDateTime");
		var EndDate = EndDateTime.split(' - ')[0];
		var EndTime = EndDateTime.split(' - ')[1];		
		var sum = 0;
		var Incisionr = $.form.GetText("cboIncisionr");  //切口等级
		if(Incisionr.indexOf("Ⅲ类")>=0)
		{
			sum+=1;
		}
		else if(Incisionr.indexOf("Ⅳ类")>=0)
		{
			sum+=1;
		}
		var ASAScore = $.form.GetText("cboASAScore");  //麻醉分级 ASA
		if(ASAScore.indexOf("P3")>=0)
		{
			sum+=1;
		}
		else if(ASAScore.indexOf("P4")>=0)  
		{
			sum+=1;
		}
		else if(ASAScore.indexOf("P5")>=0)  
		{
			sum+=1;
		}
		if(OperDate!==""&&SttTime!=""&&EndDate!=""&&EndTime!="")
		{
			var DtDiff= $.Tool.RunServerMethod("DHCHAI.IO.FromHisSrv","GetDateTimeDiff",OperDate,SttTime,EndDate,EndTime);
			if(parseInt(DtDiff)>(3*60*60))
			{
				sum+=1;
			}
		}		
		$.form.SetValue('cboNNISLevel',"",sum+"");  //计算出的NNIS评分
	};
}