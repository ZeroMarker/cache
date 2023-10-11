//页面Gui
var obj = new Object();
function InitBPRegPatWin(){
	var IsCheckFlag=false;
	//默认日期类型
    $HUI.combobox("#cboDateType",{
		data:[
			{value:'1',text:'住院日期',selected:true},
			{value:'2',text:'登记日期'},
			{value:'3',text:'透析日期'}
		],
		valueField:'value',
		textField:'text'
	});
	//设置开始日期为当月1号
	var date=new Date()
	date.setDate(1);
	var DateFrom=Common_GetDate(date);
	var DateTo=Common_GetDate(new Date());
	Common_SetValue('DateFrom',DateFrom);
    Common_SetValue('DateTo',DateTo);
    obj.PAEpisodeID = "";
    obj.PAPatientID = "";
    obj.PABPRegID   = "";
    obj.Birthday    = "";
	obj.AdmType     = "";
	//医院
    $HUI.combobox("#cboHospital",{
		url:$URL+'?ClassName=DHCHAI.BTS.HospitalSrv&QueryName=QryHospListByLogon&ResultSetType=Array&aLogonHospID='+$.LOGON.HOSPID,
		valueField:'ID',
		textField:'HospDesc',
		editable:false,
		onLoadSuccess:function(data){
			// 院区默认选择
			$('#cboHospital').combobox('select',data[0].ID);
			Common_ComboToLoc('cboPAAdmLoc',data[0].ID,"","","");
		}
	});
	//透析科室
	obj.cboBDLocation  = $HUI.combobox("#cboBDLocation", {
		url: $URL,
		editable: true,
		allowNull: true, 
		multiple:true,
		rowStyle:'checkbox',
		defaultFilter:4,     //text字段包含匹配或拼音首字母包含匹配 不区分大小写
		valueField: 'LocID',
		textField: 'LocDesc2',
		onBeforeLoad: function (param) {    //在请求加载数据之前触发，返回 false 则取消加载动作
			param.ClassName = 'DHCHAI.IRS.BPSurverySrv';
			param.QueryName = 'QryBPLocation';
			param.ResultSetType = 'array';
		}
	});
	var HospIDs 	= $("#cboHospital").combobox('getValue');
	var DateType 	= $("#cboDateType").combobox('getValue');
	var DateFrom 	= $("#DateFrom").datebox('getValue');
	var DateTo 		= $("#DateTo").datebox('getValue');
	var PatName 	= $("#txtPatName").val();
	var PapmiNo 	= $("#txtPapmiNo").val();
	var MrNo 		= $("#txtMrNo").val();
	var BDLocIDs 	= $('#cboBDLocation').combobox('getValues').join(',');	
	var aInputs = HospIDs+'^'+DateFrom+'^'+DateTo+'^'+PatName+'^'+PapmiNo+'^'+MrNo+'^'+BDLocIDs+'^'+DateType;
	 //病例列表
	 obj.gridAdm = $HUI.datagrid("#gridAdm",{
		fit: true,
		title: "血透病例列表",
		headerCls:'panel-header-gray',
		iconCls:'icon-resort',
		pagination: true, //如果为true, 则在DataGrid控件底部显示分页工具栏
		rownumbers: false, //如果为true, 则显示一个行号列
		singleSelect: true,
		autoRowHeight: false, //定义是否设置基于该行内容的行高度。设置为 false，则可以提高加载性能
		loadMsg:'数据加载中...',
		pageSize: 50,
		pageList : [20,50,100,200,1000],
		 //是否是服务器对数据排序
        sortOrder:'asc',
	    url:$URL,
	    queryParams:{
		    ClassName:"DHCHAI.DPS.BPRegisterSrv",
			QueryName:"QryBPAdm",
			aIntputs:aInputs
	    },	    
		columns:[[
			{field:'PapmiNo',title:'登记号',width:100,sortable:true},
			{field:'PAMrNo',title:'病案号',width:100,sortable:true},
			{field:'PAPatName',title:'姓名',width:100,sortable:true},
			{field:'PAPatSex',title:'性别',width:50,sortable:true},
			{field:'PAPatAge',title:'年龄',width:70,sortable:true},
			{field:'PABirthday',title:'出生日期',width:100,sortable:true,sorter:Sort_int},
			{field:'PAPatType',title:'就诊类型',width:100,sortable:true},
			{field:'AdmDate',title:'入院日期',width:100,sortable:true,sorter:Sort_int},
			{field:'DischDate',title:'出院日期',width:100,sortable:true,sorter:Sort_int},
			{field:'PAStartDate',title:'首次透析日期',width:120,sortable:true,sorter:Sort_int},
			{field:'PAEndDate',title:'结束透析日期',width:120,sortable:true,sorter:Sort_int},
			{field:'AdmLocDesc',title:'透析科室',width:150,sortable:true},
			{field:'PAHDTime',title:'透析次数',width:100,sortable:true},
			{field:'PAAdmDoc',title:'主管医生',width:100,sortable:true},
			{field:'PAAdmNurse',title:'主管护士',width:100,sortable:true},
			{field:'PAEpiInfo',title:'传染病类型',width:100,sortable:true},
			{field:'PABPPatType',title:'病人类型',width:150,sortable:true},
			{field:'PADiagnosis',title:'血透相关诊断',width:150,sortable:true},
			{field:'PAStatusDate',title:'转归日期',width:100,sortable:true,sorter:Sort_int},
			{field:'PAStatusTime',title:'转归时间',width:100,sortable:true},
			{field:'PARegDate',title:'登记日期',width:100,sortable:true},
			{field:'PARegTime',title:'登记时间',width:100,sortable:true},
			{field:'PARelTel',title:'联系电话',width:150,sortable:true},
			{field:'PAEpisodeID',title:'HIS就诊号',width:100,sortable:true},
			{field:'PAPatientID',title:'HIS病人ID',width:100,sortable:true},
			{field:'PABPRegID',title:'血透登记ID',width:100,sortable:true}
			
		]],	
		onDblClickRow:function(rindex, rowdata) {
			if (rindex>-1) {
				//obj.AddBPPatEdit();
				//obj.ClearData();
				//obj.InitRegInfo(rowdata);
			}
		},
		onLoadSuccess:function(data){
			dispalyEasyUILoad(); //隐藏效果
		}
	});
	obj.AddBPPatEdit = function(){
		$('#AddBPPatEdit').dialog({
			title: '新增血透患者',
			iconCls:"icon-w-paper",
			headerCls:'panel-header-gray',
			modal: true
		});
		$HUI.dialog('#AddBPPatEdit').open();
	}
	
	$HUI.combobox("#cboPABPPatType",{
		data:[{Id:'1',text:'常规'},{Id:'2',text:'临时'}],
		valueField:'Id',
		textField:'text'
	});
	$HUI.combobox("#cboPAEpiInfo",{
		data:[{Id:'1',text:'HBV-乙肝'},{Id:'2',text:'HCV-丙肝'},{Id:'2',text:'HIV-艾滋病'},{Id:'2',text:'SP-梅毒'},{Id:'2',text:'Negative-阴性'}],
		valueField:'Id',
		textField:'text'
	});
	
	InitBPRegPatWinEvent(obj);
	obj.LoadEvent(arguments);
	return obj;
}
$(function () {
	InitBPRegPatWin();
});