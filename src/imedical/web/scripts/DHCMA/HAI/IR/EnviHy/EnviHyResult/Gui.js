//页面gui
var objScreen = new Object();
function InitviewScreen(){
	var obj = objScreen;
	
    $.parser.parse(); // 解析整个页面
	if (typeof EnviHyMaxSpecimen=="undefined"){
		EnviHyMaxSpecimen=$m({
			ClassName:"DHCHAI.BT.Config",
			MethodName:"GetValByCode",
			aCode:"EnviHyMaxSpecimen"
		});
	}
	
    LogonHospID=$.LOGON.HOSPID;
	LogonUserID=$.LOGON.USERID;
	LogonLocID=$.LOGON.LOCID;
	LogonLocDesc=$.LOGON.LOCDESC;
	//页签切换参数值
	obj.TabArgs = new Object();
	obj.TabArgs.ContentID = '';	
	//报告信息、录入结果
	obj.ReportObj = null;
	obj.arrResult = null;
	//状态列表
	obj.StatusOrder = ServerObj.StatusList;
	obj.StatusDicList = ServerObj.StatusDicList;
	
	//医院列表
	var HospList = $cm ({
		ClassName:"DHCHAI.BTS.HospitalSrv",
		QueryName:"QryHospListByLogon",
		aLogonHospID:LogonHospID
	},false);
	obj.HospData = HospList.rows;
    
    $HUI.combobox("#cboHospital",{
		valueField:'ID',
		textField:'HospDesc',
		editable:false,
		data:obj.HospData,
		onSelect:function(rec){//给医院增加Select事件，更新科室列表
			obj.TabArgs.HospIDs=rec.ID
			Common_LookupToLoc('txtMonitorLocDesc','txtMonitorLocID',obj.TabArgs.HospIDs,'','');
			if ($('#txtMonitorLocID').val()!="") {
				$("#txtMonitorLocDesc").lookup('clear');
				$('#txtMonitorLocID').val('');
			}
		},onLoadSuccess:function(data){
			// 院区默认选择
			$('#cboHospital').combobox('select',data[0].ID);
		}
	})
	//监测项目列表
	$HUI.combobox("#cboEvItem", {
		multiple:true,
		rowStyle:'checkbox',
		panelHeight:300,
		editable:true,
		valueField:'ID',
		textField:'ItemDesc',
		onShowPanel: function () {		
			var url=$URL+"?ClassName=DHCHAI.IRS.EnviHyLocItemsSrv&QueryName=QryLocItems&ResultSetType=Array&aLocID="+""+"&aEvItemFL="+$('#cboEvItemFL').combobox('getValue');
			$("#cboEvItem").combobox('reload',url);
		}
	});
	var cboEvItemFLList = $cm ({
		ClassName:"DHCHAI.BTS.DictionarySrv",
		QueryName:"QryDic",
		aTypeCode:"EHItemType"
	},false);
	obj.EvItemFL = cboEvItemFLList.rows;
	$HUI.combobox("#cboEvItemFL",{
		valueField:'ID',
		textField:'DicDesc',
		editable:false,
		data:obj.EvItemFL,
		onSelect:function(rec){
			//Common_ComboToLoc('cboMonitorLoc',rec.ID);
			$HUI.combobox("#cboEvItem", {
				valueField:'ID',
				textField:'ItemDesc',
				onShowPanel: function () {
					//var url=$URL+"?ClassName=DHCHAI.IRS.EnviHyItemSrv&QueryName=QryEvItem&aIsActive=1&ResultSetType=Array&EvItemFL="+rec.ID;
					if (tDHCMedMenuOper['Admin']=="1"){
						var url=$URL+"?ClassName=DHCHAI.IRS.EnviHyLocItemsSrv&QueryName=QryLocItems&ResultSetType=Array&aLocID="+""+"&aEvItemFL="+rec.ID;
					}else{
						var url=$URL+"?ClassName=DHCHAI.IRS.EnviHyLocItemsSrv&QueryName=QryLocItems&ResultSetType=Array&aLocID="+$('#cboMonitorLoc').combobox('getValue')+"&aEvItemFL="+rec.ID;
					}
					$("#cboEvItem").combobox('reload',url);
				}
			});
		},onLoadSuccess:function(data){
			// 院区默认选择
			//Common_ComboDicID('cboItemType','EHItemType');
			//$('#cboEvItemFL').combobox('select',data[0].ID);
		}
	});
	//状态列表
	obj.cboStatus=Common_ComboDicCode('cboStatus','EHRepStatus');
	obj.cboStatus1=Common_ComboDicCode('cboStatus1','EHRepStatus');
	obj.cboStatus1=Common_ComboDicCode('cboStatus2','EHRepStatus');
	//是否合格列表
	obj.cboStandard=Common_ComboDicCode('cboStandard','EHStandard');
	//开始日期、结束日期
	obj.TabArgs.SttDate    = Common_GetCalDate(-7);
	obj.TabArgs.EndDate    = Common_GetDate(new Date());
	obj.txtStartDate = $('#txtStartDate').datebox('setValue', obj.TabArgs.SttDate);
	obj.txtEndDate = $('#txtEndDate').datebox('setValue', obj.TabArgs.EndDate);
	
	obj.gridReuslt =$HUI.datagrid("#gridReuslt",{
		fit: true,
		pagination: true, //如果为true, 则在DataGrid控件底部显示分页工具栏
		rownumbers: true, //如果为true, 则显示一个行号列
		singleSelect: false,  //是否允许多选
		autoRowHeight: false, //定义是否设置基于该行内容的行高度。设置为 false，则可以提高加载性能
		fitColumns: false, //设置为 true，则会自动扩大或缩小列的尺寸以适应网格的宽度并且防止水平滚动。
		loadMsg:'数据加载中...',
		pageSize: 20,
		pageList : [20,50,100,200],
		sortOrder:'asc',
		remoteSort:false,
		columns:[[
			{field:'checkOrd',checkbox:'true',align:'center',width:'60',auto:false,sortable:true},
			{field:'ReportID',title:'ID',align:'center',width:'60',sortable:true,sortable:true},
			{field:"BarCode",title:"申请号",width:120,sortable:true,
	        	formatter:function(value,row,index){
		        	if (row.ReCheckSign == '1'){
						return '┏' + value+"&nbsp";
					} else if (row.ReCheckSign == '2'){
						return '┃' + value+"&nbsp";
					} else if (row.ReCheckSign == '3'){
						return '┗' + value+"&nbsp";
					} else {
						return value;
					}
		        }
	        },
			{field:'ItemDesc',title:'监测项目',width:'180',sortable:true},
			{field:'ItemObjDesc',title:'监测对象',width:'100',sortable:true},
			{field:'StatusDesc',title:'&nbsp;&nbsp;状态',align:'left',width:'100',sortable:true,
				formatter: function(value,row,index){
					var btn = '<a style="padding-left:5px;" href="#" onclick="objScreen.winReportLog_show(\'' + row["ReportID"] + '\')">' + value + '</a>';
					return btn;
				}
			},
			{field:'MonitorDate',title:'监测日期',align:'center',width:'100',sortable:true,sorter:Sort_int},
			{field:'MonitorLocDesc',title:'监测科室',width:'100',sortable:true},
			{field:'SpecTypeDesc',title:'标本类型',width:'80',sortable:true},
			{field:'SpecimenNum',title:'标本数量',align:'center',width:'80',sortable:true},
			{field:'StandardDesc',title:'是否合格',align:'center',width:'80',sortable:true,
				styler: function(value,row,index){
					if (value=="不合格"){
						return 'background-color:#FF7256;';
					}else if (value=="合格"){
						return 'background-color:green;'
						}
					else{
						return 'background-color:#AAAAAA;'
					}
				},
				formatter: function(value,row,index){
					if (value=="") value="无结果";
					var btn = '<a href="#" style="color:#fff;" onclick="objScreen.winEnterResult_show(\'' + row["ReportID"] + '\',\'\')">' + value + '</a>';
					return btn;
				}
			},
			{field:'EnterTypeDesc',title:'录入方式',width:'80',sortable:true},
			{field:'IsReCheck',title:'是否复检',width:'80',sortable:true,
				formatter: function(value,row,index){
					return (value == 1 ? "是" : "否");
				}
			},
			{field:'ApplyDate',title:'申请日期',width:'100',sortable:true,sorter:Sort_int},
			{field:'ApplyTime',title:'申请时间',width:'80',sortable:true,sorter:Sort_int},
			{field:'ApplyLocDesc',title:'申请科室',width:'100',sortable:true},
			{field:'ApplyUserDesc',title:'申请人',width:'80',sortable:true},
			{field:'CollDate',title:'采集日期',width:'100',sortable:true,sorter:Sort_int},
			{field:'CollTime',title:'采集时间',width:'80',sortable:true,sorter:Sort_int},
			{field:'CollUserDesc',title:'采集人',width:'80',sortable:true},
			{field:'RecDate',title:'接收日期',width:'100',sortable:true,sorter:Sort_int},
			{field:'RecTime',title:'接收时间',width:'80',sortable:true,sorter:Sort_int},
			{field:'RecUserDesc',title:'接收人',width:'80',sortable:true},
			{field:'RepDate',title:'报告日期',width:'100',sortable:true,sorter:Sort_int},
			{field:'RepTime',title:'报告时间',width:'80',sortable:true,sorter:Sort_int},
			{field:'RepLocDesc',title:'报告科室',width:'80',sortable:true},
			{field:'RepUserDesc',title:'报告人',width:'80',sortable:true},
			{field:'StatusCode',title:'修改状态',align:'center',width:'80',sortable:true,
				formatter: function(value,row,index){
					var btn = '<a href="#" onclick="objScreen.winUpStatus_show(\'' + row["ReportID"] + '\',\'\')">' + "修改状态" + '</a>';
					return btn;
				}
			}
		]],
		onDblClickRow:function(rowIndex,rowData){
			if(rowIndex>-1){
				//双击事件
				obj.winEnterResult_show(rowData['ReportID'],'');
				$("#gridReuslt").datagrid("clearSelections");
			}
		},
		onLoadSuccess:function(data){
			dispalyEasyUILoad(); //隐藏效果
			//加载成功
			$("#gridReuslt").datagrid("clearSelections");
			//控制操作按钮显示
			//1申请、2材料发放、3标本接收、4录入结果、5、审核结果、6采集标本、0删除
			var StatusCode=$('#cboStatus').combobox('getValue');
			if (obj.TabArgs.ContentID.indexOf('Qry')>-1){
				$('#btnBarcode').show();
				if (obj.StatusOrder.indexOf('|5|')>-1) {
					//需要审核
					if (StatusCode == 5){
						$('#btnPrtReps').show();
					} else {
						$('#btnPrtReps').hide();
					}
				} else {
					//不需要审核
					if (StatusCode == 4){
						$('#btnPrtReps').show();
					} else {
						$('#btnPrtReps').hide();
					}
				}
			} else if (obj.TabArgs.ContentID.indexOf('IssuMat')>-1){
				$('#btnBarcode').show();
				if (StatusCode == 1){
					$('#btnIssuMat').show();
				} else {
					$('#btnIssuMat').hide();
				}
				
			}else if (obj.TabArgs.ContentID.indexOf('ColSpec')>-1){
				if (StatusCode == 2){
					$('#btnColSpec').show();
				} else {
					$('#btnColSpec').hide();
				}
				
			} else if (obj.TabArgs.ContentID.indexOf('RecSpec')>-1){
				$('#btnBarcode').show();
				if (obj.StatusOrder.indexOf('|6|')>-1) {
					//需要采集标本
					if (StatusCode == 6){
						$('#btnRecSpec').show();
					} else {
						$('#btnRecSpec').hide();
					}
				} else if (obj.StatusOrder.indexOf('|2|')>-1) {
					//需要发放材料
					if (StatusCode == 2){
						$('#btnRecSpec').show();
					} else {
						$('#btnRecSpec').hide();
					}
				} else {
					if (StatusCode == 1){
						$('#btnRecSpec').show();
					} else {
						$('#btnRecSpec').hide();
					}
				}
				$("#txtBarcode").show();
				$('#txtBarcode').val("");
				$('#txtBarcode').focus();
			} else if (obj.TabArgs.ContentID.indexOf('WriteReps')>-1){
				$('#btnBarcode').show();
				$("#txtBarcode").show();
				$('#txtBarcode').val("");
				$('#txtBarcode').focus();
				if (obj.StatusOrder.indexOf('|5|')>-1) {
					//需要审核
					if (StatusCode == 5){
						$('#btnPrtReps').show();
					} else {
						$('#btnPrtReps').hide();
					}
				} else {
					//不需要审核
					if (StatusCode == 4){
						$('#btnPrtReps').show();
					} else {
						$('#btnPrtReps').hide();
					}
				}
			}else if (obj.TabArgs.ContentID.indexOf('CheckReps')>-1){
				if (StatusCode == 5){
					$('#btnPrtReps').show();
					$('#btnChkReps').hide();
				}else if (StatusCode == 4){
					$('#btnChkReps').show();
					$('#btnPrtReps').hide();
				} else {
					$('#btnChkReps').hide();
					$('#btnPrtReps').hide();
				}
			}
		}
		
	});
	
	//录入结果弹出窗
	$('#winEnterResult').dialog({
		title: '录入结果',
		iconCls:'icon-w-paper',
		closed: true,
		modal: true,
		isTopZindex:true,
		buttons:[{
			text:'保存',
			id:'winEnterResult_btnSave',
			handler:function(){
				obj.winEnterResult_btnSave_click();
				$HUI.dialog('#winEnterResult').close();
			}
		},{
			text:'关闭',
			handler:function(){
				bClose = true;
				$HUI.dialog('#winEnterResult').close();
			}
		}]
		,onBeforeOpen:function(){//弹出框之前初始
        	bClose = true;
		 }
		,onBeforeClose:function(){//关闭弹出框之前动作
        	if (!bClose) {  
              return bClose;  //通过全局变量来控制是否关闭窗口  
			}
		 }
	});
	//修改状态弹出窗
	$('#winUpdateStatus').dialog({
		title: '修改状态',
		iconCls:'icon-w-paper',
		closed: true,
		modal: true,
		height:167,
		isTopZindex:true,
		buttons:[{
			text:'保存',
			id:'winUpdateStatus_btnSave',
			handler:function(){
				obj.winUpdateStatus_btnSave_click();
				$HUI.dialog('#winUpdateStatus').close();
			}
		},{
			text:'关闭',
			handler:function(){
				bClose = true;
				$HUI.dialog('#winUpdateStatus').close();
			}
		}]
		,onBeforeOpen:function(){//弹出框之前初始
        	bClose = true;
		 }
		,onBeforeClose:function(){//关闭弹出框之前动作
        	if (!bClose) {  
              return bClose;  //通过全局变量来控制是否关闭窗口  
			}
		 }
	});
	//报告状态列表窗
	$('#winStatusList').dialog({
		title: '状态列表',
		iconCls:'icon-w-paper',
		closed: true,
		modal: true,
		isTopZindex:true
	});
		//修改状态弹出窗
	$('#winUpdateStatus1').dialog({
		title: '批量修改状态',
		iconCls:'icon-w-paper',
		closed: true,
		modal: true,
		height:167,
		isTopZindex:true,
		buttons:[{
			text:'保存',
			id:'winUpdateStatus_btnSave1',
			handler:function(){
				obj.winUpdateStatus_btnSave_click1();
				$HUI.dialog('#winUpdateStatus1').close();
			}
		},{
			text:'关闭',
			handler:function(){
				bClose = true;
				$HUI.dialog('#winUpdateStatus1').close();
			}
		}]
		,onBeforeOpen:function(){//弹出框之前初始
        	bClose = true;
		 }
		,onBeforeClose:function(){//关闭弹出框之前动作
        	if (!bClose) {  
              return bClose;  //通过全局变量来控制是否关闭窗口  
			}
		 }
	});

	InitviewScreenEvent(obj);
	obj.LoadEvent(arguments);
	return obj;
}