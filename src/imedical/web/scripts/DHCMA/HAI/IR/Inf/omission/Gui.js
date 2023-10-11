//页面Gui
var obj = new Object();
function InitOmissionWin(){
	var IsCheckFlag=false;
	//医院
    $HUI.combobox("#cboHospital",{
		url:$URL+'?ClassName=DHCHAI.BTS.HospitalSrv&QueryName=QryHospListByLogon&ResultSetType=Array&aLogonHospID='+$.LOGON.HOSPID,
		valueField:'ID',
		textField:'HospDesc',
		editable:false,
		onSelect:function(rec){
			Common_ComboToLoc('cboLocation',rec.ID,"","I","E");
		},
		onLoadSuccess:function(data){
			// 院区默认选择
			$('#cboHospital').combobox('select',data[0].ID);
		}
	});
	$('#cboLocation').combobox({}); //联动表格需先初始化
	var date=new Date()
	date.setDate(1);
	var DateFrom=Common_GetDate(date);
	var DateTo=Common_GetDate(new Date());
	Common_SetValue('DateFrom',DateFrom);
    Common_SetValue('DateTo',DateTo);
	//就诊列表
	 obj.gridAdm = $HUI.datagrid("#gridAdm",{
		fit: true,
		title: "",
		headerCls:'panel-header-gray',
		iconCls:'icon-resort',
		pagination: true, //如果为true, 则在DataGrid控件底部显示分页工具栏
		rownumbers: false, //如果为true, 则显示一个行号列
		singleSelect: true,
		autoRowHeight: false, //定义是否设置基于该行内容的行高度。设置为 false，则可以提高加载性能
		loadMsg:'数据加载中...',
		loading:true,
		
		//是否是服务器对数据排序
		sortOrder:'asc',
		remoteSort:false,
		pageSize: 20,
		pageList : [20,50,100],
		columns:[[
			{field:'PapmiNo',title:'登记号',width:100,align:'left',sortable:true},
			{field:'MrNo',title:'病案号',width:100,align:'left',sortable:true},
			{field:'PatName',title:'姓名',width:70,align:'left',sortable:true},
			{field:'Sex',title:'性别',width:50,align:'left',sortable:true},
			{field:'Age',title:'年龄',width:70,align:'left',sortable:true},
			{field:'link',title:'摘要',width:50,align:'left',
				formatter:function(value,row,index){
					 return '<a href="#" onclick=obj.btnAbstractMsg_Click(\''+row.EpisodeID+'\')>摘要</a>';
				}
			},
			{field:'tmpInfPosDescs',title:'感染部位',width:120,align:'left',sortable:true},
			{field:'InfDate',title:'感染日期',width:100,align:'left',sortable:true,sorter:Sort_int},
			{field:'InfLocDesc',title:'感染科室',width:120,align:'left',sortable:true},
			{field:'RepDate',title:'报告日期',width:100,align:'left',sortable:true,sorter:Sort_int},
			{field:'RepUser',title:'报告人',width:100,align:'left',sortable:true},
			{field:'AdmType',title:'就诊类型',width:80,align:'left',sortable:true},
			{field:'AdmDateTime',title:'入院时间',width:160,align:'left',sortable:true},
			{field:'AdmLocDesc',title:'科室',width:120,align:'left',sortable:true},
			{field:'AdmWardDesc',title:'病区',width:120,align:'left',sortable:true},
			{field:'DischDateTime',title:'出院时间',width:160,align:'left',sortable:true},
			{field:'IsDeath',title:'死亡标志',width:70,align:'left',sortable:true}
		]],
		onSelect:function(rowIndex,rowData){
			if(!IsCheckFlag){
				IsCheckFlag = true;
				rowIndexTo=rowIndex;
			}else if(rowIndexTo==rowIndex){
				IsCheckFlag = false;
				$('#gridAdm').datagrid("unselectRow",rowIndex);
			}else{
				IsCheckFlag = false;
			}
		},
		onLoadSuccess:function(data){
			dispalyEasyUILoad(); //隐藏效果
		}
	});
	
	InitOmissionWinEvent(obj);
	obj.LoadEvent(arguments);
	return obj;
}
$(function () {
	InitOmissionWin();
});
