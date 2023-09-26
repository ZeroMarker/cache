function InitLab(obj){
	$.form.SelectRender('cboTestSet');
	$.form.SelectRender('cboBacteria');
	$.form.SelectRender('cboAntibiotic');
	obj.refreshgridINFLab = function(){
		// 病原学检验信息
		obj.INFLab = $.Tool.RunQuery('DHCHAI.IRS.INFLabSrv','QryINFLabByRep',ReportID,'');
		obj.INFLab.LabBactSen=[];
		for (var i=0;i<obj.INFLab.record.length;i++){
			var INFlabID = obj.INFLab.record[i].ID;
			var LabBactSen = $.Tool.RunQuery('DHCHAI.IRS.INFLabSrv','QryLabBactSen',INFlabID);
			obj.INFLab.LabBactSen.push(LabBactSen.record);
		}
		if(obj.gridINFLab==undefined)
		{
			obj.gridINFLab = $("#gridINFLab").DataTable({
				dom: 'rt',
				paging:false,
				select: 'single',
				ordering: false,
				data: obj.INFLab.record,
				columns: [
					{"data": "TSDesc"}
					,{"data": "SubmissLoc"}
					,{"data": "Specimen"}
					,{"data": "SubmissDate"}
					,{"data": "AssayMethod"}
					,{"data": "Bacterias"}
					,{"data": "PathogenTest"}
				]
			});
		}else{
			obj.gridINFLab.clear();
			for (var i=0;i<obj.INFLab.record.length;i++){
				obj.gridINFLab.row.add(obj.INFLab.record[i]).draw();
			}
		}
	}
	obj.refreshgridINFLab();

	function refreshgridINFLabSync(){
		if(obj.gridINFLabSync==undefined)
		{
			obj.gridINFLabSync = $("#gridINFLabSync").DataTable({
				dom: 'rt',
				paging:false,
				select: 'single',
				ordering: false,
				ajax: {
					"url": "dhchai.query.datatables.csp",
					"data": function (d) {
						d.ClassName = "DHCHAI.IRS.INFLabSrv";
						d.QueryName = "QryINFLabByRep";
						d.Arg1 = '';
						d.Arg2 = EpisodeID;
						d.ArgCnt = 2;
					}
				},
				columns: [
					{"data": "TSDesc"}
					,{"data": "Specimen"}
					,{"data": "SubmissDate"}
					,{"data": "SubmissLoc"}
					,{"data": "AssayMethod"}
					,{"data": "PathogenTest"}
					,{"data": "Bacterias"}
				]
			});
			obj.gridINFLabSync.on('dblclick', 'tr', function(e) {
				var data  = obj.gridINFLabSync.row(this).data();
				if (typeof(data)=='undefined') return;
				layer.closeAll();
				OpenINFLabEdit(data,'');
			});
		}else{
			obj.gridINFLabSync.ajax.reload(function(){});
		}
	}

	// 弹出病原学检验弹框
	function OpenINFLabEdit(d,r){
		obj.LayerOpenINFLabEdit = layer.open({
				type: 1,
				zIndex: 100,
				maxmin: false,
				title: "病原学检验信息-编辑", 
				area: ['900px','500px'],
				content: $('#LayerOpenINFLabEdit'),
				btnAlign: 'c',
				btn: ['保存','取消'],
				yes: function(index, layero){
				  	// 添加数据
					INFLabAdd(d,r);
				}
				,success: function(layero){
					InitINFLabEditData(d,r);
				}
		});	
	}

	function INFLabAdd(d,r){
		var TSDesc = $.form.GetText("cboTestSet");
		var SubmissLocID = $.form.GetValue("cboSubmissLoc");
		if (SubmissLocID==''){
			var SubmissLoc = '';
		}else{
			var SubmissLoc = $.form.GetText("cboSubmissLoc");
		}
		var AssayMethodID = $.form.GetValue("cboAssayMethod");
		if (AssayMethodID==''){
			var AssayMethod = '';
		}else{
			var AssayMethod = $.form.GetText("cboAssayMethod");
		}
		var SpecimenID = $.form.GetValue("cboSpecimen");
		if (SpecimenID==''){
			var Specimen = '';
		}else{
			var Specimen = $.form.GetText("cboSpecimen");
		}
		var PathogenTestID = $.form.GetValue("cboPathogenTest");
		if (PathogenTestID==''){
			var PathogenTest = '';
		}else{
			var PathogenTest = $.form.GetText("cboPathogenTest");
		}
		var SubmissDate = $.form.GetValue("txtSubmissDate");
		var BacteriaIDs = '';
		var Bacterias = '';
		for (var i=0;i<obj.gridRstSen.data().length;i++){
			var BacteriaID = obj.gridRstSen.data()[i].BacteriaID;
			var Bacteria = obj.gridRstSen.data()[i].Bacteria;
			if (BacteriaIDs.indexOf(BacteriaID)<0){
				BacteriaIDs = BacteriaIDs+','+BacteriaID;
			}
			if (Bacterias.indexOf(Bacteria)<0){
				Bacterias = Bacterias+','+Bacteria;
			}
		}
		if (BacteriaIDs!=''){
			BacteriaIDs = BacteriaIDs.substring(1);
		}
		if (Bacterias!=''){
			Bacterias = Bacterias.substring(1);
		}
		if (($.form.GetValue("cboTestSet")=='')&&(TSDesc=='--请选择--')){
    		layer.msg('检验医嘱不能为空!',{icon: 2});
			return;
    	}
    	if (SubmissLocID==''){
    		layer.msg('送检科室不能为空!',{icon: 2});
			return;
    	}
    	if (AssayMethodID==''){
    		layer.msg('检验方法不能为空!',{icon: 2});
			return;
    	}
    	if (SpecimenID==''){
    		layer.msg('标本不能为空!',{icon: 2});
			return;
    	}
    	if (PathogenTestID==''){
    		layer.msg('病原学检验不能为空!',{icon: 2});
			return;
    	}
    	if (SubmissDate==''){
    		layer.msg('送检日期不能为空!',{icon: 2});
			return;
    	}
    	if (!obj.checkDate(SubmissDate)){
			layer.msg('送检时间需要在住院期间!',{icon: 2});
			return;
		}
		// 药敏结果不能为空
		if (obj.gridRstSen.data().length==0){
			layer.msg('药敏结果不能为空!',{icon: 2});
			return;
		}
		var row ={
			'ID':d.ID,
			'EpisodeID':EpisodeID,
			'LabRepID':d.LabRepID,
			'TSDesc':TSDesc,
			'TSDesc2':'',
			'SpecimenID':SpecimenID,
			'Specimen':Specimen,
			'SubmissDate':SubmissDate,
			'SubmissLocID':SubmissLocID,
			'SubmissLoc':SubmissLoc,
			'AssayMethodID':AssayMethodID,
			'AssayMethod':AssayMethod,
			'PathogenTestID':PathogenTestID,
			'PathogenTest':PathogenTest,
			'BacteriaIDs':BacteriaIDs,	
			'Bacterias':Bacterias,
			'UpdateDate':'',
			'UpdateTime':'',
			',UpdateUserID':$.LOGON.USERID,
			'UpdateUser':''
		}

		// 数据重复标志
    	var dataRepeatFlg = 0;
    	for (var i=0;i<obj.gridINFLab.data().length;i++){
    		if (r) {
    			if ($(r).context._DT_RowIndex==i){
    				continue;
    			}
    		}
    		if ((TSDesc==obj.gridINFLab.data()[i].TSDesc)&&(SubmissDate==obj.gridINFLab.data()[i].SubmissDate)){
    			dataRepeatFlg = 1;
    		}
    	}
    	if (dataRepeatFlg == 1) {
    		layer.confirm('存在送检日期、检验医嘱相同的记录,是否添加病原学检验信息？', {
			  btn: ['是','否'] //按钮
			}, function(){
				InsertLab(r,row);
			});
    	}else{
    		InsertLab(r,row);
    	};
	}

	function InsertLab(r,row){
		if (r){  //修改
			var rowIndex = $(r).context._DT_RowIndex; //行号
			obj.INFLab.LabBactSen[rowIndex]=obj.gridRstSen.data();
			obj.gridINFLab.row(r).data(row).draw();
		}else{	//添加
			obj.gridINFLab.row.add(row).draw();
			obj.INFLab.LabBactSen.push(obj.gridRstSen.data());
		}
		// 关闭弹框
		layer.closeAll();
	}
	// 病原学检验编辑框信息初始化
	function InitINFLabEditData(d,r){
		// 渲染控件
		$("#cboSubmissLoc").attr("data-param",$.LOGON.HOSPID+"^Arg^I^E")			//设置科室参数
		$.form.SelectRender1('cboSubmissLoc',1);
		$.form.SelectRender('cboAssayMethod');
		$.form.SelectRender1('cboSpecimen',1);
		$.form.SelectRender('cboPathogenTest');
		$.form.SelectRender('cboRstSen');
		$.form.SetValue("cboBacteria",'','');
		$.form.SetValue("cboAntibiotic",'','');
		refreshgridRstSen([]);
		if (d){
			// 控件赋值
			if (r){
				// 加载院感报告药敏结果
				var rowIndex = $(r).context._DT_RowIndex; //行号
				refreshgridRstSen(obj.INFLab.LabBactSen[rowIndex]);
			}else{
				// 加载检验报告药敏结果
				var runQuery = $.Tool.RunQuery('DHCHAI.IRS.INFLabSrv','QryLabBactSen',d.ID,d.LabRepID);
				refreshgridRstSen(runQuery.record);
			}
			$.form.DateRender('txtSubmissDate',d.SubmissDate);
			$.form.SetValue("cboTestSet",'',d.TSDesc);
			$("#cboSubmissLoc").append(new Option(d.SubmissLoc, d.SubmissLocID, false, true));
			$.form.SetValue("cboAssayMethod",d.AssayMethodID,d.AssayMethod);
			$("#cboSpecimen").append(new Option(d.Specimen, d.SpecimenID, false, true));
			$.form.SetValue("cboPathogenTest",d.PathogenTestID,d.PathogenTest);
		}else{
			$.form.DateRender('txtSubmissDate','');
			$.form.SetValue("cboTestSet",'','');
		}
	}

	function refreshgridRstSen(data){
		if(obj.gridRstSen==undefined)
		{
			obj.gridRstSen = $("#gridRstSen").DataTable({
				dom: 'rt',
				paging:false,
				select: 'single',
				ordering: false,
				data: data,
				scrollY:"150px",
				columns: [
					{"data": "Bacteria"}
					,{"data": "AntDesc"}
					,{"data": "Sensitivity"}
				],
				fnDrawCallback: function (oSettings) {
					$("#gridRstSen_wrapper .dataTables_scrollBody").mCustomScrollbar({
						theme : "dark-thick",
						axis: "y",
						scrollInertia: 100
					});	
		        }
			});
			obj.gridRstSen.on('click', 'tr', function(e) {
				if (obj.gridRstSen.data().length>0){
					if (obj.gridRstSenID !=obj.gridRstSen.row(this).index()){
						var data = obj.gridRstSen.row(this).data();
						obj.gridRstSenID = obj.gridRstSen.row(this).index()		//选中的药敏数据行号
						$.form.SetValue("cboBacteria",data.BacteriaID,data.Bacteria);
						$.form.SetValue("cboAntibiotic",data.AntID,data.AntDesc);
						$.form.SetValue("cboRstSen",data.SensitivityID,data.Sensitivity);
					}else{
						obj.gridRstSenID=-1;
						$.form.SetValue("cboBacteria",'','');
						$.form.SetValue("cboAntibiotic",'','');
						$.form.SetValue("cboRstSen",'','');
					}
				}
			});
//			$("#gridRstSen_wrapper .dataTables_scrollBody").mCustomScrollbar({
//				scrollButtons: { enable: false },
//				theme : "dark-thick",
//				axis: "y"
//			});
		}else{
			obj.gridRstSen.clear();
			for (var i=0;i<data.length;i++){
				obj.gridRstSen.row.add(data[i]);
			}
			obj.gridRstSen.draw();
		}
	}

	function OpenINFLabSync(){
		refreshgridINFLabSync();
		obj.LayerOpenINFLabSync = layer.open({
				type: 1,
				zIndex: 100,
				maxmin: false,
				title: "病原学检验信息-提取[双击数据进行编辑]", 
				area: '75%',
				content: $('#LayerOpenINFLabSync')
		});	
	}
	// 添加病原学检验事件
	$("#btnINFLabAdd").click(function(e){
		OpenINFLabEdit('','');
	});
	// 病原学检验提取事件
	$('#btnINFLabSync').click(function(e){
		// TODO同步检验数据
		$.Tool.RunServerMethod('DHCHAI.DI.DHS.SyncLabInfo','SyncLabVisitNumber',LISSCode,EpisodeIDx,ServiceDate,ServiceDate);
		$.Tool.RunServerMethod('DHCHAI.DI.DHS.SyncLabInfo','SyncLabRepByDate',LISSCode,EpisodeIDx,ServiceDate,ServiceDate);
		OpenINFLabSync();
	});
	// 删除病原学检验事件
	$("#btnINFLabDel").click(function(e){
		var selectedRows = obj.gridINFLab.rows({selected: true}).count();
		if (selectedRows!== 1 ) {
			layer.msg('请选择一行数据!',{icon: 2});
			return;
		}else{
			var rowIndx = obj.gridINFLab.rows({selected: true}).indexes()[0];	//行
			var rd = obj.gridINFLab.rows({selected: true}).data().toArray()[0];
			layer.confirm('是否删除病原学检验：'+rd.TSDesc+'？', {
			  btn: ['是','否'] //按钮
			}, function(){
				obj.gridINFLab.rows({selected:true}).remove().draw(false);
				var tmpArray = []
				for (i=0;i<obj.INFLab.LabBactSen.length;i++){
					if (i!==rowIndx){
						tmpArray.push(obj.INFLab.LabBactSen[i]);
					}
				}
				obj.INFLab.LabBactSen = tmpArray;
				layer.msg('删除病原学检验成功！', {icon: 1});
			});
		}
	});
	// 病原学检验信息列表双击事件
	obj.gridINFLab.on('dblclick', 'tr', function(e) {
		var data  = obj.gridINFLab.row(this).data();
		if (typeof(data)=='undefined') return;
		OpenINFLabEdit(data,this);
	});
	// 添加病原体药敏信息
	obj.gridRstSenID = -1;
	$('#btnAddSen').click(function(e){
		var BacteriaID = $.form.GetValue("cboBacteria");
		var Bacteria = $.form.GetText("cboBacteria");
		var AntID = $.form.GetValue("cboAntibiotic");
		var AntDesc = $.form.GetText("cboAntibiotic");
		var SensitivityID = $.form.GetValue("cboRstSen");
		var Sensitivity = $.form.GetText("cboRstSen");
		if (BacteriaID==''){
			layer.msg('病原体不能为空!',{icon: 2});
			return;
		}
		if (AntID==''){
			layer.msg('抗生素不能为空!',{icon: 2});
			return;
		}
		if (AntID==''){
			layer.msg('药敏结果不能为空!',{icon: 2});
			return;
		}
		var row ={
			'ReportID':'',
			'ReusltID':'',
			'SenID':'',
			'BacteriaID':BacteriaID,
			'Bacteria':Bacteria,
			'AntID':AntID,
			'AntCode':'',
			'AntDesc':AntDesc,
			'SensitivityID':SensitivityID,
			'Sensitivity':Sensitivity
		}
		// 抗生素、细菌重复
		var dataRepeatFlg = 0;
    	for (var i=0;i<obj.gridRstSen.data().length;i++){
    		if (obj.gridRstSenID==i){
    			continue;
    		}
    		if ((Bacteria==obj.gridRstSen.data()[i].Bacteria)&&(AntDesc==obj.gridRstSen.data()[i].AntDesc)){
    			dataRepeatFlg = 1;
    		}
    	}
    	if (dataRepeatFlg == 1) {
    		layer.msg('存在病原体、抗菌药物相同的记录!',{icon: 2});
			return;
    	}
		if (obj.gridRstSenID==-1){
				obj.gridRstSen.row.add(row).draw();
			}else{
				obj.gridRstSen.row(obj.gridRstSenID).data(row).draw();
		}
		$("#gridRstSen_wrapper .dataTables_scrollBody").mCustomScrollbar("scrollTo",$("#gridRstSen tr td:last"));
		
	});
	// 删除病原体药敏信息
	$('#btnDelSen').click(function(e){
		var selectedRows = obj.gridRstSen.rows({selected: true}).count();
		if ( selectedRows !== 1 ){
			layer.msg('请选择要删除的数据!',{icon: 2});
			return;
		}else{
			layer.confirm('是否删除该条病原学数据？', {
				btn: ['是','否'] //按钮
			}, function(){
				var rd = obj.gridRstSen.rows({selected: true}).data().toArray()[0];
				obj.gridRstSen.rows({selected:true}).remove().draw(false);
				obj.gridRstSenID = -1;
				layer.msg('删除病原学检验成功！', {icon: 1});
			});
		}
	});
	
	obj.LAB_Save = function(){
		// 病原学检验
    	var InputLab = '';
    	for (var i=0;i<obj.gridINFLab.data().length;i++){
    		var Input = typeof(obj.gridINFLab.data()[i].ID)=='undefined'?'':obj.gridINFLab.data()[i].ID;
    		Input = Input + CHR_1 + obj.gridINFLab.data()[i].EpisodeID;
    		Input = Input + CHR_1 + (typeof(obj.gridINFLab.data()[i].LabRepID)=='undefined'?'':obj.gridINFLab.data()[i].LabRepID);
    		Input = Input + CHR_1 + obj.gridINFLab.data()[i].TSDesc;
    		Input = Input + CHR_1 + obj.gridINFLab.data()[i].TSDesc2;
    		Input = Input + CHR_1 + obj.gridINFLab.data()[i].SpecimenID;
    		Input = Input + CHR_1 + obj.gridINFLab.data()[i].SubmissDate;
    		Input = Input + CHR_1 + obj.gridINFLab.data()[i].SubmissLocID;
    		Input = Input + CHR_1 + obj.gridINFLab.data()[i].AssayMethodID;
    		Input = Input + CHR_1 + obj.gridINFLab.data()[i].PathogenTestID;
    		Input = Input + CHR_1 + '';
    		Input = Input + CHR_1 + '';
    		Input = Input + CHR_1 + $.LOGON.USERID;
    		Input = Input + CHR_1 + $.LOGON.USERID; 
    		// 药敏
    		var SenDatas='';
    		for (var j=0;j<obj.INFLab.LabBactSen[i].length;j++){
    			var SenData = '';
    			SenData = SenData + CHR_1 + obj.INFLab.LabBactSen[i][j].BacteriaID;
    			SenData = SenData + CHR_1 + obj.INFLab.LabBactSen[i][j].Bacteria;
    			SenData = SenData + CHR_1 + obj.INFLab.LabBactSen[i][j].AntID;
    			SenData = SenData + CHR_1 + obj.INFLab.LabBactSen[i][j].AntDesc;
    			SenData = SenData + CHR_1 + obj.INFLab.LabBactSen[i][j].SensitivityID;
    			SenData = SenData + CHR_1 + obj.INFLab.LabBactSen[i][j].Sensitivity;
    			SenDatas = SenDatas + CHR_3 + SenData;
    		}
    		if (SenDatas) SenDatas = SenDatas.substring(1,SenDatas.length);
    		Input = Input + CHR_4 + SenDatas;
    		InputLab = InputLab + CHR_2 + Input;
    	}
    	if (InputLab) InputLab = InputLab.substring(1,InputLab.length);
    	return InputLab;
	}
}