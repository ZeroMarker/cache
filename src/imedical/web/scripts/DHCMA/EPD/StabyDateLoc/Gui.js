//页面gui
var objScreen = new Object();
function InitviewScreen(){
	var obj = objScreen;	
    $.parser.parse(); // 解析整个页面
	obj.DateFrom = $('#DateFrom').datebox('setValue', Common_GetDate(new Date()));    // 日期初始赋值
	obj.DateTo = $('#DateTo').datebox('setValue', Common_GetDate(new Date()));
	//初始查询条件
    obj.cboSSHosp = Common_ComboToSSHosp("cboSSHosp",SSHospCode,"EPD");  
    //医院科室联动
	$HUI.combobox('#cboSSHosp',{
	    onSelect:function(rows){
		    var HospID=rows["CTHospID"];
		    obj.cboLoc = Common_ComboToLoc("cboLoc","E","","",HospID);
	    }
    });

	obj.gridEpdQuery =$HUI.datagrid("#gridEpdQuery",{
		fit: true,
		pagination: true, //如果为true, 则在DataGrid控件底部显示分页工具栏
		rownumbers: true, //如果为true, 则显示一个行号列
		singleSelect:false,
		autoRowHeight: false, //定义是否设置基于该行内容的行高度。设置为 false，则可以提高加载性能
		loadMsg:'数据加载中...',
		pageSize: 20,
		pageList : [20,50,100,200],
	    url:$URL,
	    queryParams:{
		    ClassName:"DHCMed.EPDService.EpidemicSrv",
			QueryName:"QueryEpdRepByDate",
			FromDate: $('#DateFrom').datebox('getValue'), 
			ToDate: $('#DateTo').datebox('getValue'),
			Loc: $('#cboLoc').combobox('getValue'),
			Hospital: $('#cboSSHosp').combobox('getValue')
	    },
		columns:[[
			{field:'IsUpload',title:'是否上报CDC',width:'100'},
			{field:'Paadm',title:'病历浏览',width:80,align:'center',
			  	formatter: function(value,row,index){
				  	return " <a href='#' style='white-space:normal; color:blue' onclick='objScreen.OpenEMR(\"" + row.Paadm + "\",\"" + row.PatientID + "\");'>病历浏览</a>";
			  	}
			},	
			{field:'Status',title:'报告状态',width:'70'},
			{field:'RegNo',title:'登记号',width:'110'},
			{field:'PatientName',title:'患者姓名',width:'150'},
			{field:'Sex',title:'性别',width:'50'},
			{field:'Age',title:'年龄',width:'50'},
			{field:'EncryptLevel',title:'病人密级',width:'70'},
			{field:'PatLevel',title:'病人级别',width:'150'},
			{field:'Address',title:'现住址',width:'250'},
			{field:'DiseaseName',title:'疾病名称',width:'250'},
			{field:'RepKind',title:'疾病类别',width:'100'},
			{field:'TelPhone',title:'联系电话',width:'150'},
			{field:'RepUserName',title:'报告人',width:'120'},
			{field:'ReportDep',title:'报告科室',width:'150'},
			{field:'RepPlace',title:'上报位置',width:'100'},
			{field:'RepNo',title:'卡片编号',width:'150'},
			{field:'FamName',title:'家长姓名',width:'110'},
			{field:'PersonalID',title:'身份证号',width:'200'},
			{field:'Occupation',title:'职业',width:'150'},
			{field:'Company',title:'工作单位',width:'150'},
			{field:'RepRank',title:'疾病等级',width:'150'},
			{field:'SickDate',title:'发病日期',width:'120'},
			{field:'DiagDate',title:'诊断日期',width:'120'},
			{field:'DeathDate',title:'死亡日期',width:'120'},
			{field:'RepUserCode',title:'报告人工号',width:'150'},
			{field:'RepDate',title:'报告日期',width:'120'},
			{field:'RepTime',title:'报告时间',width:'90'},
			{field:'CheckUserName',title:'审核人',width:'150'},
			{field:'CheckUserCode',title:'审核人工号',width:'150'},
			{field:'CheckDate',title:'审核日期',width:'120'},
			{field:'CheckTime',title:'审核时间',width:'90'},
			{field:'DelReason',title:'退回/删除原因',width:'150'},
			{field:'DemoInfo',title:'备注',width:'150'},
			{field:'RowID',title:'RowID',hidden:true}		
		]],
		onDblClickRow:function(rowIndex,rowData){
			console.info(rowData.RowID);
			obj.openHandler(rowData.RowID);
		}
	});
	obj.StatDataGridPanel =$HUI.datagrid("#StatDataGridPanel",{
		fit: true,
		//pagination: true, //如果为true, 则在DataGrid控件底部显示分页工具栏
		rownumbers: true, //如果为true, 则显示一个行号列
		singleSelect:false,
		autoRowHeight: false, //定义是否设置基于该行内容的行高度。设置为 false，则可以提高加载性能
		loadMsg:'数据加载中...',
		pageSize: 20,
		pageList : [20,50,100,200],
	    url:$URL,
	    queryParams:{
		    ClassName:"DHCMed.EPDService.EpdStaSrv",
			QueryName:"StaEpdByDate",
			FromDate: $('#DateFrom').datebox('getValue'), 
			ToDate: $('#DateTo').datebox('getValue'),
			Loc: $('#cboLoc').combobox('getValue'),
			Hospital: $('#cboSSHosp').combobox('getValue')
	    },
		columns:[[
			{field:'DataDesc',title:'科室/疾病',width:'100'},
			{field:'EpdNum',title:'病例数量',width:'70'},
			{field:'EpdRatio',title:'比例',width:'100'},
			{field:'RowID',title:'RowID',hidden:true}		
		]],
		onDblClickRow:function(rowIndex,rowData){
			console.info(rowData.RowID);
			obj.openHandler(rowData.RowID);
		}
	});
	InitviewScreenEvent(obj);
	obj.LoadEvent(arguments);	
	return obj;
}