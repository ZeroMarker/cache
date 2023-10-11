var objScreen = new Object();
function InitEnviHyMiniWin(){
	var obj = objScreen;	
	obj.AdminPower=0;
	if (tDHCMedMenuOper['Admin']==1) {
		obj.AdminPower =1;
	}		
	obj.Report ='';
	obj.HospData = ''; 
  	$.parser.parse(); // 解析EasyUI组件
	LogonHospID=$.LOGON.HOSPID;
	LogonUserID=$.LOGON.USERID;
	LogonLocID=$.LOGON.LOCID;
	LogonLocDesc=$.LOGON.LOCDESC;
	
	var HospList = $cm ({
		ClassName:"DHCHAI.BTS.HospitalSrv",
		QueryName:"QryHospListByLogon",
		aLogonHospID:$.LOGON.HOSPID
	},false);
	obj.HospData = HospList.rows;
	
	$HUI.combobox("#cboHospital",{
		valueField:'ID',
		textField:'HospDesc',
		editable:false,
		data:obj.HospData,
		onSelect:function(rec){
			Common_ComboToLoc('cboMonitorLoc',rec.ID);
		},onLoadSuccess:function(data){
			// 院区默认选择
			$('#cboHospital').combobox('select',data[0].ID);
		}
	});
	$('#cboMonitorLoc').combobox({}); //联动表格需先初始化
	
	
	//是否合格列表
	obj.cboStandard=Common_ComboDicCode('cboStandard','EHStandard');
	
	var date=new Date()
	date.setDate(1);
	var DateFrom=Common_GetDate(date);
	var DateTo=Common_GetDate(new Date());
	Common_SetValue('txtStartDate',DateFrom);
    Common_SetValue('txtEndDate',DateTo);
    
    $HUI.combobox("#cboAHospital",{
		valueField:'ID',
		textField:'HospDesc',
		editable:false,
		data:obj.HospData,
		onSelect:function(rec){
			Common_ComboToLoc('cboALoc',rec.ID);
		},onLoadSuccess:function(data){
			// 院区默认选择
			$('#cboAHospital').combobox('select',data[0].ID);
		}
	});
	$('#cboALoc').combobox({}); //联动表格需先初始化
			
	obj.gridReuslt =$HUI.datagrid("#gridReuslt",{
		fit: true,
		pagination: true, //如果为true, 则在DataGrid控件底部显示分页工具栏
		rownumbers: false, //如果为true, 则显示一个行号列
		singleSelect: false,  //是否允许多选
		autoRowHeight: false, //定义是否设置基于该行内容的行高度。设置为 false，则可以提高加载性能
		//fitColumns: true, //设置为 true，则会自动扩大或缩小列的尺寸以适应网格的宽度并且防止水平滚动。
		loadMsg:'数据加载中...',
		pageSize: 20,
		pageList : [20,50,100,200],
	    url:$URL,
	    overflow:true,
	    queryParams:{
		    ClassName:"DHCHAI.IRS.EnviHyReportSrv",
			QueryName:"QryEvReport",
			aHospIDs:$("#cboHospital").combobox('getValue'),
			aDateType:'MonitorDate',
			aDateFrom:$("#txtStartDate").datebox('getValue'),
			aDateTo:$("#txtEndDate").datebox('getValue'),
			aMonitorLoc:$("#cboMonitorLoc").combobox('getValue'),
			aItemID:'',
			aStatusCode:'',
			aFlowFlg:'',
			aStandard:'',
	    },
		columns:[[
			{field:"BarCode",title:"申请号",width:120},
			{field:'EvItemDesc',title:'监测项目',sortable:true},
			{field:'EvItemObjDesc',title:'监测对象',sortable:true,
				formatter: function(value,row,index){
					if (value=="") {
						return row["ItemObjTxt"];
					}else{
						return value
					}
				}
			},
			{field:'MonitorDate',title:'监测日期',align:'center',sortable:true},
			{field:'MonitorLocDesc',title:'监测科室',sortable:true},
			{field:'SpenTypeDesc',title:'标本类型',align:'center',sortable:true},
			{field:'SpecimenNum',title:'标本数量',align:'center',sortable:true},
			{field:'StandardDesc',title:'是否合格',align:'center',sortable:true,
				styler: function(value,row,index){
					if (value=="不合格"){
						return 'background-color:#FFEDEB;color:#FF1414;';
					}else if (value=="合格"){
						return 'background-color:#F8FFF3;color:#229A06;';
					}else{
						return 'background-color:#ECECEC;color:#000000;';
					}
				},
				formatter:function(value,row,index){
					if (value=="") (value="无结果")
		        	if (row.ReCheckSign == '1'){
						return  value;
					} else if (row.ReCheckSign == '2'){
						return value;
					} else if (row.ReCheckSign == '3'){
						return  value;
					} else {
						return value;
					}
		        }
			},
			{field:'EnterTypeDesc',title:'录入方式',sortable:true},
			{field:'ApplyDate',title:'申请日期',sortable:true},
			{field:'ApplyTime',title:'申请时间',sortable:true},
			{field:'ApplyLocDesc',title:'申请科室',sortable:true},
			{field:'ApplyUserDesc',title:'申请人',sortable:true},
			{field:'RepDate',title:'报告日期',sortable:true},
			{field:'RepTime',title:'报告时间',sortable:true},
			{field:'RepLocDesc',title:'报告科室',sortable:true},
			{field:'RepUserDesc',title:'报告人',sortable:true},
			{field:'Resume',title:'备注',sortable:true}
		]],
		onDblClickRow:function(rowIndex,rowData){
			if(rowIndex>-1){
				//双击事件
				obj.Report=rowData;
				obj.winEnterResult_show(rowData,'1');
				$("#gridReuslt").datagrid("clearSelections");
			}
		},
		onLoadSuccess:function(data){	
		}
	});
	
    InitEnviHyMiniWinEvent(obj);
	obj.loadEvents();
		
	return obj;
}