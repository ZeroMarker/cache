//页面Gui
var objScreen = new Object();
function InitQryHandInfPosWin(){
	var obj = objScreen;
	obj.DiagnosID='';
	obj.IsReportDiag ='';
	$.parser.parse(); // 解析EasyUI组件
	
	//设置开始日期和结束日期为本月第一天
	var date=new Date()
	date.setDate(1);
	var DateFrom=Common_GetDate(date)
	Common_SetValue('DateFrom',DateFrom);
    //医院
    $HUI.combobox("#cboHospital",{
		url:$URL+'?ClassName=DHCHAI.BTS.HospitalSrv&QueryName=QryHospListByLogon&ResultSetType=Array&aLogonHospID='+$.LOGON.HOSPID,
		valueField:'ID',
		textField:'HospDesc',
		editable:false,
		onSelect:function(rec){
			Common_ComboToLoc('cboLoc',rec.ID,"","I","");
		},
		onLoadSuccess:function(data){
			// 院区默认选择
			$('#cboHospital').combobox('select',data[0].ID);
		}
	});
	$('#cboLoc').combobox({}); //联动表格需先初始化
	
	//加载调查方式下拉框
	$HUI.combobox("#cboMethod",{
		url:$URL+'?ClassName=DHCHAI.BTS.DictionarySrv&QueryName=QryDic&ResultSetType=Array&aTypeCode='+"HandHyObsMethod",
		valueField:'ID',
		textField:'DicDesc',
	
	});
	
	
	obj.gridQryHandByDate=$('#QryHandByDate').datagrid({
        fit:true,
        title:'手卫生统计查询',
        headerCls:'panel-header-gray',
		iconCls:'icon-resort',
        pagination: true, //如果为true, 则在DataGrid控件底部显示分页工具栏
        rownumbers:true,
        singleSelect:false,
        autoRowHeight: false, //定义是否设置基于该行内容的行高度。设置为 false，则可以提高加载性能
		loadMsg:'数据加载中...',
		loading:true,
		pageSize: 20,
		pageList : [20,50,100,200],
	    columns:[[
	        { field:"HandHyObsType",title:"调查对象类型",width:'180',align:'center'},
			{ field:"HandHyObsTime",title:"调查时机",width:'150',align:'center'},
			{ field:"HandHyObsMethod",title:"调查方式",width:'150',align:'center'},
			{ field:"HandHyOpp",title:"手卫生指征",width:'240',align:'center'},
			{ field:"HandHyFac",title:"手卫生行为",width:'170',align:'center'},
			{ field:"HHIsGloving",title:"是否戴手套",width:'120',align:'center'},
			{ field:"HHIsCorrect",title:"是否正确",width:'80',align:'center'},
			{ field:"HHLoc",title:"调查科室",width:'180',align:'center'},
			{ field:"HHObsPages",title:"调查页数",width:'80',align:'center'},
			{ field:"HHObsDates",title:"调查日期",width:'120',align:'center'},
			{ field:"HHObsUser",title:"调查人",width:'110',align:'center'},
			{ field:"HHRegDate",title:"登记日期",width:'180',align:'center'},
			{ field:"HHRegUser",title:"登记人",width:'170',align:'center'},
			//HandHyObsType,HandHyObsTime,HandHyOpp,HandHyFac,HHIsGloving,HHIsCorrect,HHLoc,HHObsPage,HHObsDate,HHObsUser,HHRegDate,HHRegUser
			
						

        ]],
		onLoadSuccess:function(data){
			dispalyEasyUILoad(); //隐藏效果
		}
    });
	

	InitQryHandInfPosWinEvent(obj);
	obj.LoadEvent(arguments);

	return obj;
}
