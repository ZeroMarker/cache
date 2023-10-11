//页面gui
var objScreen = new Object();
function InitPatQry(){
	var obj = objScreen;	
    $.parser.parse(); // 解析整个页面
	obj.DateFrom = $('#DateFrom').datebox('setValue', Common_GetDate(new Date()));    // 日期初始赋值
	obj.DateTo = $('#DateTo').datebox('setValue', Common_GetDate(new Date()));
	//初始查询条件
    obj.cboSSHosp = Common_ComboToSSHosp("cboSSHosp",SSHospCode,"EPD");  
	//上报位置下拉框
	obj.cboRepPlace = Common_ComboDicCode('cboRepPlace','RepPlace');
    //医院科室联动
	$HUI.combobox('#cboSSHosp',{	
	    onSelect:function(rows){
		    var HospID=rows["CTHospID"];
		    obj.cboLoc = Common_ComboToLoc("cboLoc","E","","",HospID);
	    }
    });
  	$('#cboDateType').combobox({      
		valueField:'Code',    
		textField:'Desc',
		data : [ {
			Code:'1', 
			Desc:'就诊日期',
			"selected":true   
		},{
			Code:'2', 
			Desc:'出院日期'
		}]
	});
	
	
	
	obj.gridPatQuery =$HUI.datagrid("#gridPatQuery",{
		fit: true,
		title: "患者查询列表",
		headerCls:'panel-header-gray',
		iconCls:'icon-apply-check',
		pagination: true, //如果为true, 则在DataGrid控件底部显示分页工具栏
		rownumbers: true, //如果为true, 则显示一个行号列
		singleSelect:false,
		autoRowHeight: false, //定义是否设置基于该行内容的行高度。设置为 false，则可以提高加载性能
		loadMsg:'数据加载中...',
		pageSize: 20,
		pageList : [20,50,100,200],
		columns:[[
			{field:'AdmType',title:'就诊类型',width:100,align:'center'},
			{field:'PapmiNo',title:'登记号',width:120,align:'center'},
			{field:'LocDesc',title:'科室',width:120,align:'center'},
			{field:'PatName',title:'姓名',width:120,align:'center'},
			{field:'PatSex',title:'性别',width:120,align:'center'},
			{field:'PatAge',title:'年龄',width:100,align:'center'},
			{field:'link',title:'病历浏览',width:120,align:'center',
			  	formatter: function(value,row,index){
					var EpisodeID = row["RowID"];
					var PatientID = row["PatientID"];
					return " <a href='#' style='white-space:normal; color:blue' onclick='objScreen.OpenEMR(\"" + EpisodeID + "\",\"" + PatientID + "\");'>病历浏览</a>";
			  	}
			},	
			{field:'DiagDesc',title:'诊断',width:220,align:'center',showTip:true},
			{field:'IsReAdmDesc',title:'复诊',width:80,align:'center'},
			{field:'AdmDoc',title:'就诊医生',width:120,align:'center'},
			{field:'Bed',title:'床号',width:120,align:'center'},
			{field:'AdmDate',title:'就诊日期',width:220,align:'center'},
			{field:'DischDate',title:'出院日期',width:220,align:'center'},
			{field:'Address',title:'现住址',width:120,align:'center'},
			{field:'IDNumber',title:'证件号',width:120,align:'center'},
			{field:'Telephone',title:'联系电话',width:120,align:'center'},
			{field:'IsWoBorn',title:'本地或外地',width:140,align:'center'},
			{field:'IsReportEPD',title:'传染病是否报卡',width:140,align:'center'},
			{field:'EPDRepInfo',title:'传染病信息',width:300,align:'center',showTip:true},
			{field:'MrNo',title:'病案号',width:120,align:'center'},
			{field:'Elink',title:'传染病报告',width:150,align:'center',
				formatter: function(value,row,index){
					if ((typeof HISUIStyleCode != 'undefined') && (HISUIStyleCode=="lite")) {
						return "<a href='#' class='icon-add' data-options='plain:true,' onclick='objScreen.btnReportEPD(\"" + row.RowID + "\",\"" + row.PatientID + "\");'>上报</a>";
					} else {
						return "<a href='#' class='icon-add' data-options='plain:true,' onclick='objScreen.btnReportEPD(\"" + row.RowID + "\",\"" + row.PatientID + "\");'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;上报</a>";
					}
				}
			},
			{field:'Flink',title:'食源性疾病报告',width:200,align:'center',
				formatter: function(value,row,index){
					if ((typeof HISUIStyleCode != 'undefined') && (HISUIStyleCode=="lite")) {
						return "<a href='#' class='icon-add' data-options='plain:true,' onclick='objScreen.btnReportFBD(\"" + row.RowID + "\",\"" + row.PatientID + "\");'>上报</a>";
					} else {
						return "<a href='#' class='icon-add' data-options='plain:true,' onclick='objScreen.btnReportFBD(\"" + row.RowID + "\",\"" + row.PatientID + "\");'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;上报</a>";
					}
				}
			}
		]],
		onDblClickRow:function(rowIndex,rowData){
			obj.openHandler(rowData);
		},onLoadSuccess:function(data){
			//加载成功
			dispalyEasyUILoad(); //隐藏效果
		}
	});
	InitPatQryEvent(obj);
	obj.LoadEvent(arguments);	
	return obj;
}