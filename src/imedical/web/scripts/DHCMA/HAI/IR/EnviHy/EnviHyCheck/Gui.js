//页面gui
var objScreen = new Object();
function InitviewScreen(){
	var obj = objScreen;
    $.parser.parse(); // 解析整个页面
    LogonHospID=$.LOGON.HOSPID;
	LogonUserID=$.LOGON.USERID;
	LogonLocID=$.LOGON.LOCID;
	LogonLocDesc=$.LOGON.LOCDESC;
	
	//页签切换参数值
	obj.TabArgs = new Object();
	obj.TabArgs.ContentID    = '';
	obj.TabArgs.HospIDs      = '';
	obj.TabArgs.HospDesc     = '';
	obj.TabArgs.LocID        = '';
	obj.TabArgs.LocDesc      = '';
	obj.TabArgs.StatusCode   = '';
	obj.TabArgs.StatusDesc   = '';
	obj.TabArgs.StandardCode = '';
	obj.TabArgs.StandardDesc = '';
	obj.TabArgs.SttDate      = '';
	obj.TabArgs.EndDate      = '';
	
	//报告信息、录入结果
	obj.ReportObj = null;
	obj.arrResult = null;
	
	//获取状态执行状态列表
	obj.StatusOrder = ServerObj.StatusList;
	obj.StatusDicList = ServerObj.StatusDicList;
	
	//医院列表
	var HospList = $cm ({
		ClassName:"DHCHAI.BTS.HospitalSrv",
		QueryName:"QryHospListByLogon",
		aLogonHospID:LogonHospID
	},false);
	obj.HospData = HospList.rows;
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
			Common_LookupToLoc('txtMonitorLocDesc','txtMonitorLocID',obj.TabArgs.HospIDs,'O|I','');
			if ($('#txtMonitorLocID').val()!="") {
				$("#txtMonitorLocDesc").lookup('clear');
				$('#txtMonitorLocID').val('');
			}
		},onLoadSuccess:function(data){
			// 院区默认选择
			$('#cboHospital').combobox('select',data[0].ID);
		}
	})
	//状态列表
	obj.cboStatus=Common_ComboDicCode('cboStatus','EHRepStatus',true);
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
		fitColumns: true, //设置为 true，则会自动扩大或缩小列的尺寸以适应网格的宽度并且防止水平滚动。
		loadMsg:'数据加载中...',
		pageSize: 20,
		pageList : [20,50,100,200],
		columns:[[
			{field:'checkOrd',checkbox:'true',align:'center',auto:false},
			{field:'ReportID',title:'ID',align:'center',sortable:true},
			{field:"BarCode",title:"申请号",
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
			{field:'ItemDesc',title:'监测项目',sortable:true},
			{field:'ItemObjDesc',title:'监测对象',sortable:true},
			{field:'StatusDesc',title:'&nbsp;&nbsp;状态',align:'left',sortable:true,
				formatter: function(value,row,index){
					var btn = '<a style="padding-left:5px;" href="#" onclick="objScreen.winReportLog_show(\'' + row["ReportID"] + '\')"><span class="icon icon-add-note">&nbsp;&nbsp;&nbsp;&nbsp</span>' + value + '</a>';
					return btn;
				}
			},
			{field:'MonitorDate',title:'监测日期',align:'center',sortable:true},
			{field:'MonitorLocDesc',title:'监测科室',sortable:true},
			{field:'SpecTypeDesc',title:'标本类型',align:'center',sortable:true},
			{field:'SpecimenNum',title:'标本数量',align:'center',sortable:true},
			{field:'StandardDesc',title:'是否合格',align:'center',sortable:true,
				styler: function(value,row,index){
						if (value=="不合格"){
							return 'background-color:#FF7256;';
						}else{
							return 'background-color:#AAAAAA;'
							}
					},
				formatter: function(value,row,index){
					if (value=="") value="无结果";
					var btn = '<a href="#" style="color:#fff;" onclick="objScreen.winEnterResult_show(\'' + row["ReportID"] + '\')">' + value + '</a>';
					return btn;
				}
			},
			{field:'EnterTypeDesc',title:'录入方式',sortable:true},
			{field:'IsReCheck',title:'是否复检',sortable:true,
				formatter: function(value,row,index){
					return (value == 1 ? "是" : "否");
				}
			},
			{field:'ApplyDate',title:'申请日期',sortable:true},
			{field:'ApplyTime',title:'申请时间',sortable:true},
			{field:'ApplyLocDesc',title:'申请科室',sortable:true},
			{field:'ApplyUserDesc',title:'申请人',sortable:true},
			{field:'CollDate',title:'采集日期',sortable:true},
			{field:'CollTime',title:'采集时间',sortable:true},
			{field:'CollUserDesc',title:'采集人',sortable:true},
			{field:'RecDate',title:'接收日期',sortable:true},
			{field:'RecTime',title:'接收时间',sortable:true},
			{field:'RecUserDesc',title:'接收人',sortable:true},
			{field:'RepDate',title:'报告日期',sortable:true},
			{field:'RepTime',title:'报告时间',sortable:true},
			{field:'RepLocDesc',title:'报告科室',sortable:true},
			{field:'RepUserDesc',title:'报告人',sortable:true}
		]],
		onDblClickRow:function(rowIndex,rowData){
			if(rowIndex>-1){
				//双击事件
				obj.winEnterResult_show(rowData['ReportID']);
				$("#gridReuslt").datagrid("clearSelections");
			}
		},
		onLoadSuccess:function(data){
			//加载成功
			dispalyEasyUILoad(); //隐藏效果
			$("#gridReuslt").datagrid("clearSelections");
			//控制操作按钮显示
			//1申请、2材料发放、3标本接收、4录入结果、5、审核结果、6采集标本、0删除
			var StatusCode=$('#cboStatus').combobox('getValue');
			if (obj.TabArgs.ContentID.indexOf('Qry')>-1){
			
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
			} else if (obj.TabArgs.ContentID.indexOf('CheckReps')>-1){
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
		isTopZindex:false,//true,
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
				$HUI.dialog('#winEnterResult').close();
			}
		}]
	});
	//报告状态列表窗
	$('#winStatusList').dialog({
		title: '状态列表',
		iconCls:'icon-w-paper',
		closed: true,
		modal: true,
		isTopZindex:false
	});
	InitviewScreenEvent(obj);
	obj.LoadEvent(arguments);
	return obj;
}