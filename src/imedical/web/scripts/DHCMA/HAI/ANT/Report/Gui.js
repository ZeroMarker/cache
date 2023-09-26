var objScreen = new Object();
function InitReportWin(){	
	var obj = objScreen;

	// 弹出病人用药情况弹框
	obj.winAntiUnReactionOpen = function(){
		$HUI.dialog('#winAntiUnReaction').open();
		obj.winAntiUnReaction();
	}
	obj.winAntiUnReaction = function(){
		$HUI.datagrid("#gridAntiUnReaction",{
			fit: true,
			//title:'使用碳青霉素/替加环素类抗菌药物后不良情况(停药时填写)',
			headerCls:'panel-header-gray',
			iconCls:'icon-paper',
			pagination: true, //如果为true, 则在DataGrid控件底部显示分页工具栏
			rownumbers: true, //如果为true, 则显示一个行号列
			singleSelect: true,
			autoRowHeight: false, //定义是否设置基于该行内容的行高度。设置为 false，则可以提高加载性能
			loadMsg:'数据加载中...',
			pageSize: 20,
			pageList : [20,50,100,200],
			url:$URL,
			queryParams:{
				ClassName:"DHCHAI.ANTS.OrdAntiPatSrv",
				QueryName:"QryUnReaction",		
				aEpisodeID:EpisodeID
			},
			columns:[[
				{field:'SpecimenDesc',title:'铜绿假单胞菌<br>送检标本',width:100},
				{field:'CollDate',title:'铜绿假单胞菌<br>送检时间',width:120},
				{field:'AuthDate',title:'铜绿假单胞菌<br>报告时间',width:120},
				{field:'Specimen2Desc',title:'不动杆菌<br>送检标本',width:100},
				{field:'CollDate2',title:'不动杆菌<br>送检时间',width:120},
				{field:'AuthDate2',title:'不动杆菌<br>报告时间',width:120},
				{field:'Specimen3Desc',title:'肠杆菌<br>送检标本',width:100},
				{field:'CollDate3',title:'肠杆菌<br>送检时间',width:120},
				{field:'AuthDate3',title:'肠杆菌<br>报告时间',width:120}	
			]],
			onDblClickRow:function (rowIndex, rowData){
				if (rowIndex>-1){
					obj.openHandler(rowIndex,rowData);
				}
				$HUI.dialog('#winAntiUnReaction').close();
			}
		});
	}
	// 病人用药情况弹框
	$('#winAntiUnReaction').dialog({
		title:'使用碳青霉素/替加环素类抗菌药物后不良情况(停药时填写)--选择',
		iconCls:'icon-w-paper',
		width: 1000,
		height:500,
		closed: true, 
		modal: true,
		isTopZindex:true
	});
	//医嘱科室
	obj.cboOrdLoc = Common_ComboDicID("cboOrdLoc","ANTDepartment"); //[抗菌用药]科室		   
	//感染部位
	obj.cboInfPos = Common_ComboDicID("cboInfPos","ANTInfPos");
	
	//感染诊断
	$HUI.combobox("#cboInfDiagnos", {
		url: $URL,
		editable: false,       //因测试组测试输入非字典内容，小字典统一不允许编辑
		allowNull: true,
		defaultFilter:4,     
		valueField: 'ID',
		textField: 'Desc',
		onBeforeLoad: function (param) {    //在请求加载数据之前触发，返回 false 则取消加载动作
			param.ClassName = 'DHCHAI.BTS.InfPosSrv';
			param.QueryName = 'QryInfPosToSelect';
			param.aPosFlg = 2;
			param.ResultSetType = 'array';
		}
	});
	//适应症
	obj.cboIndication = Common_ComboDicID("cboIndication","ANTIndication")
	//处方权限
	obj.cboQuePower = Common_ComboDicID("cboQuePower","ANTQuePower")
	//用药效果
	obj.cboUseDrugRes = Common_ComboDicID("cboUseDrugRes","ANTUseDrugRes")
	//调整方案
	obj.cboAdjustPlan = Common_ComboDicID("cboAdjustPlan","ANTAdjustPlan")
	//送检标本
	obj.cboSpecimen = Common_ComboDicID("cboSpecimen","ANTSpecimen")
	obj.cboSpecimen2 = Common_ComboDicID("cboSpecimen2","ANTSpecimen")
	obj.cboSpecimen3 = Common_ComboDicID("cboSpecimen3","ANTSpecimen")
	//用药名称
	obj.cboAntiDurg = Common_ComboDicID("cboAntiDurg","ANTAntibiotic")
	//不良反应
	obj.chkUnReaction = Common_CheckboxToDic("chkUnReaction","ANTUnReaction","");
	
	//入院诊断鼠标悬浮事件
	$('#txtAdmDiagnos').hover(function(){
		var AdmitDiag = $('#txtAdmDiagnos').val();
		if (AdmitDiag!='') {
			$("#txtAdmDiagnos").popover({
				content:AdmitDiag,
				trigger:'hover',
				placement:'bottom'
			});
			$("#txtAdmDiagnos").popover('show'); 
		}
	});
	
	//APACHE II评分鼠标悬浮事件
	$('#txtAPACHEII').hover(function(){
		var APACHEII = $('#txtAPACHEII').val();
		if (APACHEII!='') {
			$("#txtAPACHEII").popover({
				content:APACHEII,
				trigger:'hover',
				placement:'bottom'
			});
			$("#txtAPACHEII").popover('show'); 
		}			
	});
	
	InitReportWinEvent(obj);
	InitEtiologyEvi(obj);
	obj.LoadEvent(arguments);
	return obj;
}