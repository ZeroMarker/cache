function InitLab(obj){
	obj.LabRowID = ''; //病原学检验选中行
	obj.SenRowID = ''; //药敏信息选中行
	obj.TestSetID = '';
	obj.SubmissLocID = '';
	obj.SpecimenID = '';
	obj.BacteriaID = '';
	obj.AntibioticID = '';

	obj.refreshgridINFLab = function(){
	
		// 病原学检验信息
		obj.INFLab = $cm({
			ClassName:"DHCHAI.IRS.INFLabSrv",
			QueryName:"QryINFLabByRep",		
			aReportID: ReportID
		},false);
		obj.INFLab.LabBactSen=[];
		for (var i=0;i<obj.INFLab.total;i++){
			var INFlabID = obj.INFLab.rows[i].ID;
			var LabBactSen =$cm({
				ClassName:"DHCHAI.IRS.INFLabSrv",
				QueryName:"QryLabBactSen",		
				aINFLabID: INFlabID
			},false);
			obj.INFLab.LabBactSen.push(LabBactSen.rows);
		}
		// 病原学检验信息
		obj.gridINFLab = $HUI.datagrid("#gridINFLab",{ 
			//title:'病原学检验',
			//headerCls:'panel-header-gray',
			//iconCls:'icon-paper',
			rownumbers: true, //如果为true, 则显示一个行号列
			singleSelect: true,
			autoRowHeight: false, //定义是否设置基于该行内容的行高度。设置为 false，则可以提高加载性能
			loadMsg:'数据加载中...',
			columns:[[
				{field:'TSDesc',title:'检验医嘱',width:290},
				{field:'SubmissLoc',title:'送检科室',width:160},
				{field:'Specimen',title:'标本',width:120},
				{field:'SubmissDate',title:'送检日期',width:140,
					formatter: function(value,row,index){
					return row.SubmissDate+" "+row.SubmissTime;	
					}
				},
				{field:'AssayMethod',title:'检验方法',width:120},
				{field:'Bacterias',title:'病原体',width:290,
					formatter: function(value,row,index){
						if (row.RuleMRBs) {
							return row.RuleMRBs;
						}else {
							return value;
						}
					}
				},
				{field:'PathogenTest',title:'病原学检验结果',width:120}
			]],
			onSelect:function(rindex,rowData){
				if (obj.LabRowID === rindex) {
					obj.LabRowID="";
					$("#btnINFLabDel").linkbutton("disable");
					obj.gridINFLab.clearSelections();  //清除选中行
				} else {
					obj.LabRowID = rindex;
					if ((obj.RepStatusCode==3)||(obj.RepStatusCode==4)) {  //审核、删除状态报告
						$("#btnINFLabDel").linkbutton("disable");
					}else {
						$("#btnINFLabDel").linkbutton("enable");
					}
				}	
			},
			onDblClickRow:function(rindex, rowdata) {
				if (rindex>-1) {
					OpenINFLabEdit(rowdata,rindex);
				}
			},
			onLoadSuccess:function(data){
				$("#btnINFLabDel").linkbutton("disable");
			}
		});
		
		if (ReportID) {		
			$cm ({
				ClassName:"DHCHAI.IRS.INFLabSrv",
				QueryName:"QryINFLabByRep",		
				aReportID: ReportID
			},function(rs){
				$('#gridINFLab').datagrid('loadData', rs);				
			});	
		}
	}
	obj.refreshgridINFLab();

	 // 病原学检验提取事件
	$('#btnINFLabSync').click(function(e){
		/// TODO同步检验数据
		$m({
			ClassName:"DHCHAI.DI.DHS.SyncLabInfo",
			MethodName:"SyncLabVisitNumber",
			aSCode:LISSCode,
			aEpisodeIDX:EpisodeIDx,
			aDateFrom:ServiceDate,
			aDateTo:ServiceDate
		});
		$m({
			ClassName:"DHCHAI.DI.DHS.SyncLabInfo",
			MethodName:"SyncLabRepByDate",
			aSCode:LISSCode,
			aEpisodeIDX:EpisodeIDx,
			aDateFrom:ServiceDate,
			aDateTo:ServiceDate
		});
		
		OpenINFLabSync();
	});
	
	//是否存在与此次感染相关的病原学信息
	$HUI.radio("[name='radInfLab']",{  
		onChecked:function(e,value){
			var IsInfLab = $(e.target).val();   //当前选中的值
			if (IsInfLab==1) {
				$('#divINFLab').removeAttr("style");
				OpenINFLabSync();
				obj.refreshgridINFLab();		
			}else {
				$('#gridINFLab').datagrid('loadData',{total:0,rows:[]});	
				$('#divINFLab').attr("style","display:none");
			}
		}
	});
	
	
	//病原学检验提取弹出事件
	obj.LayerOpenINFLabSync = function() {
		$HUI.dialog('#LayerOpenINFLabSync',{
			title:"病原学检验-提取 [双击数据进行编辑]", 
			iconCls:'icon-w-paper',
			width: 1200,    
			height: 500, 
			modal: true,
			isTopZindex:true
		});
	}
	// 弹出病原学检验提取框
	function OpenINFLabSync(){
		refreshgridINFLabSync();
		$('#LayerOpenINFLabSync').show();
		obj.LayerOpenINFLabSync();
	}
    //病原学检验列表
	function refreshgridINFLabSync(){	
		obj.gridINFLabSync = $HUI.datagrid("#gridINFLabSync",{
			fit:true,
			headerCls:'panel-header-gray',
			iconCls:'icon-paper',
			rownumbers: true, //如果为true, 则显示一个行号列
			singleSelect: true,
			pagination : true,//如果为true, 则在DataGrid控件底部显示分页工具栏
			pageSize: 20,
			pageList : [20,50,100,200],
			//fitColumns: true,
			loadMsg:'数据加载中...',
			url:$URL,
			queryParams:{
				ClassName:'DHCHAI.IRS.INFLabSrv',
				QueryName:'QryINFLabByRep',
				aEpisodeID:EpisodeID
			},
			columns:[[
				{field:'TSDesc',title:'检验医嘱',width:200},
				{field:'Specimen',title:'标本',width:100},
				{field:'SubmissLoc',title:'送检科室',width:120},
				{field:'SubmissDate',title:'送检日期',width:140,
					formatter: function(value,row,index){
					return row.SubmissDate+" "+row.SubmissTime;	
					}
				},
				{field:'AssayMethod',title:'检验方法',width:100},
				{field:'PathogenTest',title:'病原学检验结果',width:150},
				{field:'Bacterias',title:'病原体',width:300,
					formatter: function(value,row,index){
						if (obj.Bacterias) {
							var arrBacteria = obj.Bacterias.split(",");
							var len = arrBacteria.length;
							for (var i=0;i<len;i++) {
								var Bacteria=arrBacteria[i];
							    if (value.indexOf(Bacteria)>-1) {
								    value ="<div style='padding:5px;'><span style='background-color:#00CDCD;border-radius:5px;color:#fff;text-align:left;padding:3px;' >"+value+"</span></div>";
							    }
							}
							return value;
						}else {
							return value;
						}
					}
				}
			]],	
			onDblClickRow:function(rindex, rowdata) {
				if (rindex>-1) {
					OpenINFLabEdit(rowdata,'');
					$HUI.dialog('#LayerOpenINFLabSync').close();
				}
			}		
		});		
	}
	
	// 添加 病原学检验信息事件
	$("#btnINFLabAdd").click(function(e){
		OpenINFLabEdit('','');	
	});
	// 弹出病原学检验信息弹框
	function OpenINFLabEdit(d,r){
		$('#LayerOpenINFLabEdit').show();
		if ((obj.RepStatusCode==3)||(obj.RepStatusCode==4)) {
			obj.LayerOpenINFLabEdit();
		}else {
			$HUI.dialog('#LayerOpenINFLabEdit',{ 
				title:'病原学检验信息-编辑',
				iconCls:'icon-w-paper',
				width: 1000,
				height: 578,    
				modal: true,
				isTopZindex:true,
				buttons:[{
					text:'保存',
					handler:function(){	
						INFLabAdd(d,r);
					}
				},{
					text:'取消',
					handler:function(){$HUI.dialog('#LayerOpenINFLabEdit').close();}
				}]
			});	
		}
		InitINFLabEditData(d,r);
	}
	
	// 病原学检验信息弹框
	obj.LayerOpenINFLabEdit = function (){
		$HUI.dialog('#LayerOpenINFLabEdit',{
			title:'病原学检验信息-编辑',
			iconCls:'icon-w-paper',
			width: 1000,
			height: 535,    
			modal: true,
			isTopZindex:true
		});
	}
	
	obj.gridRstSen = $HUI.datagrid("#gridRstSen",{ 
		title:'药敏信息',
		headerCls:'panel-header-gray',
		iconCls:'icon-paper',
		rownumbers: true, //如果为true, 则显示一个行号列
		singleSelect: true,
		autoRowHeight: false, //定义是否设置基于该行内容的行高度。设置为 false，则可以提高加载性能
		loadMsg:'数据加载中...',
		columns:[[
			{field:'Bacteria',title:'病原体',width:400},
			{field:'AntDesc',title:'抗菌药物',width:400},
			{field:'Sensitivity',title:'药敏结果',width:120}
		]],
		onSelect:function(rindex,rowData){
			if (rindex>-1) {
				OnSelectRstSen();
			}
		},
		onLoadSuccess:function(data){
			$("#btnDelSen").linkbutton("disable");
		}
	});
	//选中药敏信息添加行 
	function OnSelectRstSen() {
		var rowData = obj.gridRstSen.getSelected();
		if (rowData["ID"] == obj.LabSenID) {
			obj.gridRstSenID=-1;
			obj.clearLabSenData();	
			$("#btnDelSen").linkbutton("disable");			
			obj.gridRstSen.clearSelections();  //清除选中行
		} else {
			obj.gridRstSenID = obj.gridRstSen.getRowIndex(rowData);		//选中的药敏数据行号
			obj.LabSenID = rowData["ID"];
			obj.BacteriaID = rowData.BacteriaID;
			$('#cboBacteria').lookup('setText',rowData.Bacteria);
			obj.AntibioticID = rowData.AntID;
			$('#cboAntibiotic').lookup('setText',rowData.AntDesc);
			$('#cboRstSen').combobox('setValue',rowData.SensitivityID);
			$('#cboRstSen').combobox('setText',rowData.Sensitivity);
			if ((obj.RepStatusCode==3)||(obj.RepStatusCode==4)) {  //审核、删除状态报告
				$("#btnAddSen").linkbutton("disable");
				$("#btnDelSen").linkbutton("disable");
			}else {
				$("#btnDelSen").linkbutton("enable");
			}
		}
	}
	//清除药敏信息添加行 数据
	obj.clearLabSenData = function() {
		obj.LabSenID="";
		obj.BacteriaID = '';
		$('#cboBacteria').lookup('setText','');
		obj.AntibioticID = '';
		$('#cboAntibiotic').lookup('setText','');
		$('#cboRstSen').combobox('clear');
		$("#btnINFLabDel").linkbutton("disable");	
	}
	// 添加病原体药敏信息
	obj.gridRstSenID = -1;
	$('#btnAddSen').click(function(e){
		var BacteriaID = obj.BacteriaID;
		var Bacteria = $('#cboBacteria').lookup('getText');
		var AntID = obj.AntibioticID;
		var AntDesc = $('#cboAntibiotic').lookup('getText');
		var SensitivityID = $('#cboRstSen').combobox('getValue');
		var Sensitivity = $('#cboRstSen').combobox('getText');
		var errinfo = "";
    	if (obj.BacteriaID==''){
			errinfo = errinfo + $g("请选择病原体!")+"<br>";
    	}
    	if (obj.AntibioticID==''){
    		errinfo = errinfo + $g("请选择抗生素!")+"<br>";
    	}
		if (SensitivityID==''){
    		errinfo = errinfo + $g("药敏结果不能为空!")+"<br>";
    	}
		
		if (errinfo){
			$.messager.alert("提示", errinfo, 'info');
			return;
		}
		
		var row ={
			ReportID:'',
			ReusltID:'',
			SenID:'',
			BacteriaID:BacteriaID,
			Bacteria:Bacteria,
			AntID:AntID,
			AntCode:'',
			AntDesc:AntDesc,
			SensitivityID:SensitivityID,
			Sensitivity:Sensitivity
		}
		// 抗生素、细菌重复
		var dataRepeatFlg = 0;
    	for (var i=0;i<obj.gridRstSen.getRows().length;i++){
    		if (obj.gridRstSenID==i){
    			continue;
    		}
    		if ((Bacteria==obj.gridRstSen.getRows()[i].Bacteria)&&(AntDesc==obj.gridRstSen.getRows()[i].AntDesc)){
    			dataRepeatFlg = 1;
    		}
    	}
    	if (dataRepeatFlg == 1) {
    		$.messager.alert("提示", '存在病原体、抗菌药物相同的记录!', 'info');
			return;
    	}else {
			var selectObj = obj.gridRstSen.getSelected();
			if (selectObj) {
				var ind = obj.gridRstSen.getRowIndex(selectObj);  //获取当前选中行的行号(从0开始)
				obj.gridRstSen.updateRow({  //更新指定行
					index: ind,	   // index：要插入的行索引，如果该索引值未定义，则追加新行。row：行数据。					
					row:row
				});
			}else{	//添加
				obj.gridRstSen.appendRow({  //插入一个新行
					ReportID:'',
					ReusltID:'',
					SenID:'',
					BacteriaID:BacteriaID,
					Bacteria:Bacteria,
					AntID:AntID,
					AntCode:'',
					AntDesc:AntDesc,
					SensitivityID:SensitivityID,
					Sensitivity:Sensitivity
				});
			}
		}
				
	});
	// 删除药敏信息事件
	$("#btnDelSen").click(function(e){
		var selectObj = obj.gridRstSen.getSelected();
		var index = obj.gridRstSen.getRowIndex(selectObj);  //获取当前选中行的行号(从0开始)
		if (!selectObj) {
			$.messager.alert("提示", "请选择一行要删除的药敏信息数据!", 'info');
			return;
		}else {
			$.messager.confirm("提示", "是否删除该条药敏信息数据？", function (r) {
				if (r){				
					obj.gridRstSen.deleteRow(index);
					obj.gridRstSenID = -1;
					obj.clearLabSenData();
				}
			});
		}				
	});
	// 病原学检验编辑框信息初始化
	function InitINFLabEditData(d,r){
		obj.cboTestSet = $HUI.lookup("#cboTestSet", {
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
			textField: 'TestSet',
			queryParams:{ClassName: 'DHCHAI.DPS.LabTestSetSrv',QueryName: 'QryLabTestSetMap',aActive:1},
			columns:[[    
				{field:'TestSet',title:'检验医嘱名称',width:380}  
			]],
			onBeforeLoad:function(param){
				var desc=param['q'];
				if ((desc)&&(desc.indexOf('[√]')>0)) desc=desc.split('[√]')[0];  
				param = $.extend(param,{aAlias:desc}); //将参数q转换为类中的参数
			},
			onSelect:function(index,rowData){  
				obj.TestSetID = rowData['ID'];			
			}
		});
		
		obj.cboSubmissLoc = $HUI.lookup("#cboSubmissLoc", {
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
			textField: 'LocDesc',
			queryParams:{ClassName: 'DHCHAI.BTS.LocationSrv',QueryName: 'QryLocSrv',aHospID:$.LOGON.HOSPID,aLocCate:"I",aLocType:"E",aIsActive:1,aIsGroup:1},
			columns:[[  
				{field:'LocCode',title:'科室代码',width:160},   
				{field:'LocDesc',title:'科室名称',width:260}  
			]],
			onBeforeLoad:function(param){
				var desc=param['q'];
				if (desc=="") return false;   	
				param = $.extend(param,{aAlias:desc}); //将参数q转换为类中的参数
			},
			onSelect:function(index,rowData){  
				obj.SubmissLocID = rowData['ID'];			
			}
		});
		
		obj.cboSpecimen = $HUI.lookup("#cboSpecimen", {
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
			textField: 'SpecDesc',
			queryParams:{ClassName: 'DHCHAI.DPS.LabSpecSrv',QueryName: 'QryLabSpecimen',aActive:1},
			columns:[[  
				{field:'SpecCode',title:'标本代码',width:80},   
				{field:'SpecDesc',title:'标本名称',width:200},
				{field:'IsSteDesc',title:'是否无菌部位',width:120}				
			]],
			onBeforeLoad:function(param){
				var desc=param['q'];
				//if (desc=="") return false;  
				param = $.extend(param,{aAlias:desc}); //将参数q转换为类中的参数
			},
			onSelect:function(index,rowData){  
				obj.SpecimenID = rowData['ID'];			
			}
		});
		
		obj.cboBacteria = $HUI.lookup("#cboBacteria", {
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
			textField: 'BacDesc',
			queryParams:{ClassName: 'DHCHAI.DPS.LabBactSrv',QueryName: 'QryLabBacteria'},
			columns:[[  
				{field:'BacCode',title:'病原体代码',width:90},   
				{field:'BacDesc',title:'病原体名称',width:180},
				{field:'BacName',title:'英文名称',width:160}				
			]],
			onBeforeLoad:function(param){
				var desc=param['q'];
				//if (desc=="") return false;  				
				param = $.extend(param,{aAlias:desc}); //将参数q转换为类中的参数
			},
			onSelect:function(index,rowData){  
				obj.BacteriaID = rowData['ID'];			
			}
		});
		obj.cboAntibiotic = $HUI.lookup("#cboAntibiotic", {
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
			textField: 'AntDesc',
			queryParams:{ClassName: 'DHCHAI.DPS.LabAntiSrv',QueryName: 'QryLabAntibiotic'},
			columns:[[  
				{field:'AntCode',title:'抗生素代码',width:120},   
				{field:'AntDesc',title:'抗生素名称',width:260}			
			]],
			onBeforeLoad:function(param){
				var desc=param['q'];
				//if (desc=="") return false;  
				param = $.extend(param,{aAlias:desc}); //将参数q转换为类中的参数
			},
			onSelect:function(index,rowData){  
				obj.AntibioticID = rowData['ID'];			
			}
		});
		
		obj.cboAssayMethod = Common_ComboDicID("cboAssayMethod","LABAssayMethod");
		obj.cboPathogenTest = Common_ComboDicID("cboPathogenTest","LABPathogenTest");
		obj.cboLABIsEPD = Common_ComboDicID("cboLABIsEPD","LABIsEPD");
		obj.cboRstSen = Common_ComboDicID("cboRstSen","LABTestRstSen");
	
		// 控件赋值
		if (d){
			obj.TestSetID = d.TestSetID;
			obj.SubmissLocID = d.SubmissLocID;
			obj.SpecimenID = d.SpecimenID;
			
			$('#cboTestSet').lookup('setText',d.TSDesc);
			$('#cboSubmissLoc').lookup('setText',d.SubmissLoc);
			$('#cboSpecimen').lookup('setText',d.Specimen);
			
			$('#cboAssayMethod').combobox('setValue',d.AssayMethodID);
			$('#cboAssayMethod').combobox('setText',d.AssayMethod);
			$('#cboPathogenTest').combobox('setValue',d.PathogenTestID);
			$('#cboPathogenTest').combobox('setText',d.PathogenTest);
			$('#txtSubmissDate').datebox('setValue',d.SubmissDate);
			
			$('#cboLABIsEPD').combobox('setValue',d.LABIsEPDID);
			$('#cboLABIsEPD').combobox('setText',d.LABIsEPD);
			
			if ((parseInt(r) >-1)){ // r为行号 加载院感报告药敏结果
				$('#gridRstSen').datagrid('loadData',obj.INFLab.LabBactSen[r]);
			}else{
				//加载检验报告药敏信息
				$cm ({
					ClassName:"DHCHAI.IRS.INFLabSrv",
					QueryName:"QryLabBactSen",		
					INFLabID: d.ID, 
					aLabRepID:d.LabRepID
				},function(rs){
					$('#gridRstSen').datagrid('loadData', rs);				
				});	
			}
		}else {			
			$('#cboTestSet').lookup('setText',''); 			
			$('#cboSubmissLoc').lookup('setText',''); 		
			$('#cboSpecimen').lookup('setText','');
			$('#cboAssayMethod').combobox('clear');  
			$('#cboPathogenTest').combobox('clear'); 
			$('#txtSubmissDate').datebox('clear');   
			$('#cboLABIsEPD').combobox('clear');   
			$('#cboBacteria').lookup('setText','');
			$('#cboAntibiotic').lookup('setText',''); 
			$('#cboRstSen').combobox('clear'); 	
			$('#gridRstSen').datagrid('loadData',[]);
		}
	}

	// 添加病原学检验信息到列表
	function INFLabAdd(d,r){
		var NowDate = Common_GetDate(new Date()); 
	    var AdmDate = obj.AdmInfo.rows[0].AdmDate;
		var DischDate = obj.AdmInfo.rows[0].DischDate;
		
		var TestSetID = obj.TestSetID;
		var TSDesc = $('#cboTestSet').lookup('getText');
		if (d) {  //update 20230211 处理手工添加的数据
			var LabRepID = d.LabRepID;
			if (TSDesc.indexOf('[√]')>0) TSDesc=TSDesc.split('[√]')[0];
			if ((!TestSetID)&&(TSDesc)){
				var objTestSet=$m({
					ClassName:"DHCHAI.DP.LabTestSetMap",
					MethodName:"GetObjByTestSet",
					aSCode:LISSCode,
					aTestSet:TSDesc
				},false);
				var TestSetData = JSON.parse(objTestSet);
				TestSetID = TestSetData.ID;
			}
		}
		var SubmissLocID = obj.SubmissLocID;
		var SubmissLoc = $('#cboSubmissLoc').lookup('getText');
		
		var SpecimenID = obj.SpecimenID;
		var Specimen = $('#cboSpecimen').lookup('getText');
		
		var AssayMethodID = $('#cboAssayMethod').combobox('getValue');
		if (AssayMethodID==''){
			var AssayMethod = '';
		}else{
			var AssayMethod = $('#cboAssayMethod').combobox('getText');
		}
		
		var PathogenTestID = $('#cboPathogenTest').combobox('getValue');
		if (PathogenTestID==''){
			var PathogenTest = '';
		}else{
			var PathogenTest = $('#cboPathogenTest').combobox('getText');
		}
		
		var LABIsEPDID = $('#cboLABIsEPD').combobox('getValue');
		if (LABIsEPDID==''){
			var LABIsEPD = '';
		}else{
			var LABIsEPD = $('#cboLABIsEPD').combobox('getText');
		}
		
		var SubmissDate = $('#txtSubmissDate').datebox('getValue');
		
		var BacteriaIDs = '';
		var Bacterias = '';
		if (obj.gridRstSen.getRows()) {
			for (var i=0;i<obj.gridRstSen.getRows().length;i++){
				var BacteriaID = obj.gridRstSen.getRows()[i].BacteriaID;
				var Bacteria = obj.gridRstSen.getRows()[i].Bacteria;
				if (BacteriaIDs.indexOf(BacteriaID)<0){
					BacteriaIDs = BacteriaIDs+','+BacteriaID;
				}
				if (Bacterias.indexOf(Bacteria)<0){
					Bacterias = Bacterias+','+Bacteria;
				}
			}
		}
		if (BacteriaIDs!=''){
			BacteriaIDs = BacteriaIDs.substring(1);
		}
		if (Bacterias!=''){
			Bacterias = Bacterias.substring(1);
		}
		
		var errinfo = "";
    	if (TestSetID==''){
			errinfo = errinfo + $g("请选择标准检验医嘱!")+"<br>";
    	}
    	if (obj.SubmissLocID==''){
    		errinfo = errinfo + $g("请选择送检科室!")+"<br>";
    	}
		if (obj.SpecimenID==''){
    		errinfo = errinfo + $g("请选择标本!")+"<br>";
    	}
    	
    	if (AssayMethodID==''){
			errinfo = errinfo + $g("检验方法不能为空!")+"<br>";
    	}
    	if (PathogenTestID==''){
			errinfo = errinfo + $g("病原学检验不能为空!")+"<br>";
    	}
		if (SubmissDate==''){
			errinfo = errinfo + $g("送检日期不能为空!")+"<br>";
    	}
    	if (SubmissDate) {
			if ((Common_CompareDate(AdmDate,SubmissDate)>0)||(Common_CompareDate(SubmissDate,DischDate)>0)||(Common_CompareDate(SubmissDate,NowDate)>0)) {
				errinfo = errinfo + $g("送检日期期需在住院期间且不应超出当前日期!"); 
			}
		}
		/*
		// 药敏结果不能为空
		if (obj.gridRstSen.getRows().length<1){
			errinfo = errinfo + "药敏结果不能为空!<br>";
		}
		*/
		if (errinfo !='') {
			$.messager.alert("提示", errinfo, 'info');
			return ;
		}
      
		var row ={
			ID:d.ID,
			EpisodeID:EpisodeID,
			LabRepID:d.LabRepID,
			TestSetID:TestSetID,  // 增加检验医嘱ID
			TSDesc:TSDesc,
			TSDesc2:'',
			SpecimenID:SpecimenID,
			Specimen:Specimen,
			SubmissDate:SubmissDate,
			SubmissLocID:SubmissLocID,
			SubmissLoc:SubmissLoc,
			AssayMethodID:AssayMethodID,
			AssayMethod:AssayMethod,
			PathogenTestID:PathogenTestID,
			PathogenTest:PathogenTest,
			BacteriaIDs:BacteriaIDs,	
			Bacterias:Bacterias,
			RuleMRBs:Bacterias,
			LABIsEPDID:LABIsEPDID,	
			LABIsEPD:LABIsEPD,
			UpdateDate:'',
			UpdateTime:'',
			UpdateUserID:$.LOGON.USERID,
			UpdateUser:''
		}
	
		// 数据重复标志
    	var dataRepeatFlg = 0;
    	for (var i=0;i<obj.gridINFLab.getRows().length;i++){
    		//r 为行号
			if ((parseInt(r) >-1)&&(r==i)) {	
				continue;	
			}
		
    		if ((TSDesc==obj.gridINFLab.getRows()[i].TSDesc)&&(SubmissDate==obj.gridINFLab.getRows()[i].SubmissDate)){
    			dataRepeatFlg = 1;
    		}
    	}
    	if (dataRepeatFlg == 1) {
			$.messager.confirm("提示", "存在送检日期、检验医嘱相同的记录,是否添加病原学检验信息？", function (t) {
				if (t){	
					if (parseInt(r) >-1){  //修改
						obj.gridINFLab.updateRow({  //更新指定行
							index: r,	   // index：要插入的行索引，如果该索引值未定义，则追加新行。row：行数据。
							row:row
						});
						obj.INFLab.LabBactSen[r]=obj.gridRstSen.getRows();
					}else{	//添加
						obj.gridINFLab.appendRow({  //插入一个新行
							ID:d.ID,
							EpisodeID:EpisodeID,
							LabRepID:d.LabRepID,
							TestSetID:TestSetID,  // 增加检验医嘱ID
							TSDesc:TSDesc,
							TSDesc2:'',
							SpecimenID:SpecimenID,
							Specimen:Specimen,
							SubmissDate:SubmissDate,
							SubmissLocID:SubmissLocID,
							SubmissLoc:SubmissLoc,
							AssayMethodID:AssayMethodID,
							AssayMethod:AssayMethod,
							PathogenTestID:PathogenTestID,
							PathogenTest:PathogenTest,
							BacteriaIDs:BacteriaIDs,	
							Bacterias:Bacterias,
							RuleMRBs:Bacterias,
							LABIsEPDID:LABIsEPDID,	
							LABIsEPD:LABIsEPD,
							UpdateDate:'',
							UpdateTime:'',
							UpdateUserID:$.LOGON.USERID,
							UpdateUser:''
						});
					}
					obj.INFLab.LabBactSen.push(obj.gridRstSen.getRows());
					obj.clearLabSenData();
					$HUI.dialog('#LayerOpenINFLabEdit').close();
				}				
			});
    	}else{
			if (parseInt(r) >-1){  //修改
				obj.gridINFLab.updateRow({  //更新指定行
					index: r,	   // index：要插入的行索引，如果该索引值未定义，则追加新行。row：行数据。
					row:row
				});
				obj.INFLab.LabBactSen[r]=obj.gridRstSen.getRows();
			}else{	//添加
				obj.gridINFLab.appendRow({  //插入一个新行
					ID:d.ID,
					EpisodeID:EpisodeID,
					LabRepID:d.LabRepID,
					TestSetID:TestSetID,  // 增加检验医嘱ID
					TSDesc:TSDesc,
					TSDesc2:'',
					SpecimenID:SpecimenID,
					Specimen:Specimen,
					SubmissDate:SubmissDate,
					SubmissLocID:SubmissLocID,
					SubmissLoc:SubmissLoc,
					AssayMethodID:AssayMethodID,
					AssayMethod:AssayMethod,
					PathogenTestID:PathogenTestID,
					PathogenTest:PathogenTest,
					BacteriaIDs:BacteriaIDs,	
					Bacterias:Bacterias,
					RuleMRBs:Bacterias,
					LABIsEPDID:LABIsEPDID,	
					LABIsEPD:LABIsEPD,
					UpdateDate:'',
					UpdateTime:'',
					UpdateUserID:$.LOGON.USERID,
					UpdateUser:''
				});
				obj.INFLab.LabBactSen.push(obj.gridRstSen.getRows());
			}
			obj.clearLabSenData();
			$HUI.dialog('#LayerOpenINFLabEdit').close();
    	};
	}
     
	// 删除病原学检验信息事件
	$("#btnINFLabDel").click(function(e){
		var selectObj = obj.gridINFLab.getSelected();
		var index = obj.gridINFLab.getRowIndex(selectObj);  //获取当前选中行的行号(从0开始)
		if (!selectObj) {
			$.messager.alert("提示", "请选择一行要删除的病原学检验数据!", 'info');
			return;
		}else {
			$.messager.confirm("提示", "是否删除该条病原学数据？", function (r) {
				if (r){				
					obj.gridINFLab.deleteRow(index);
					var tmpArray = []
					for (i=0;i<obj.INFLab.LabBactSen.length;i++){
						if (i!==index){
							tmpArray.push(obj.INFLab.LabBactSen[i]);
						}
					}
					obj.INFLab.LabBactSen = tmpArray;
				}
			});
		}				
	});
    
	obj.LAB_Save = function(){
		// 病原学检验
    	var InputLab = '';
    	for (var i=0;i<obj.gridINFLab.getRows().length;i++){
    		var Input = typeof(obj.gridINFLab.getRows()[i].ID)=='undefined'?'':obj.gridINFLab.getRows()[i].ID;
    		Input = Input + CHR_1 + obj.gridINFLab.getRows()[i].EpisodeID;
    		Input = Input + CHR_1 + (typeof(obj.gridINFLab.getRows()[i].LabRepID)=='undefined'?'':obj.gridINFLab.getRows()[i].LabRepID);
    		Input = Input + CHR_1 + obj.gridINFLab.getRows()[i].TSDesc;
    		Input = Input + CHR_1 + obj.gridINFLab.getRows()[i].TSDesc2;
    		Input = Input + CHR_1 + obj.gridINFLab.getRows()[i].SpecimenID;
    		Input = Input + CHR_1 + obj.gridINFLab.getRows()[i].SubmissDate;
    		Input = Input + CHR_1 + obj.gridINFLab.getRows()[i].SubmissLocID;
    		Input = Input + CHR_1 + obj.gridINFLab.getRows()[i].AssayMethodID;
    		Input = Input + CHR_1 + obj.gridINFLab.getRows()[i].PathogenTestID;
    		Input = Input + CHR_1 + '';
    		Input = Input + CHR_1 + '';
    		Input = Input + CHR_1 + $.LOGON.USERID;
    		Input = Input + CHR_1 + obj.gridINFLab.getRows()[i].LABIsEPDID; 
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