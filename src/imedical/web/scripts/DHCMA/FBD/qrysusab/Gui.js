﻿//页面Gui
var objScreen = new Object();
function InitSusAbQueryWin(){
	var obj = objScreen;		
    
    $.parser.parse(); // 解析整个页面  
    
    //初始查询条件
    obj.cboHospital = Common_ComboToSSHosp("cboHospital",SSHospCode,"FBD");
	//医院科室联动
	$HUI.combobox('#cboHospital',{
	    onSelect:function(rows){
		    var HospID=rows["CTHospID"];
		    obj.cboReportLoc = Common_ComboToLoc("cboReportLoc","E|EM","","",HospID);
	    }
    });
	var nowDate = new Date();
	nowDate.setMonth(nowDate.getMonth()-1);
    obj.dtStaDate = $('#dtStaDate').datebox('setValue', Common_GetDate(nowDate));// 日期初始赋值
    obj.dtEndDate = $('#dtEndDate').datebox('setValue', Common_GetDate(new Date()));

	$('#cboPatType').combobox({      
		valueField:'Code',    
		textField:'Desc',
		data : [ {
			Code:'O',
			Desc:'门诊'
		},{
			Code:'I',
			Desc:'病区'
		},{
			Code:'E', 
			Desc:'急诊'
		} ]
	});  
	$('#cboDateType').combobox({      
		valueField:'Code',    
		textField:'Desc',
		data : [ {
			Code:'IndexReportDate', 
			Desc:'报告日期',
			"selected":true   
		},{
			Code:'IndexCheckDate', 
			Desc:'审核日期'
		}]
	});  
   
	//疾病分类
	obj.cboDiseaseCate = Common_ComboDicID("cboDiseaseCate","FBDDiseaseType");
	//疾病分类 疾病名称联动
	$HUI.combobox('#cboDiseaseCate',{
	    onChange:function(newValue,oldValue){
		    var CateID = newValue;
			//疾病名称
			obj.cboDiseaseDesc = $HUI.combobox('#cboDiseaseDesc', {
				url: $URL,
				editable: true,
				valueField: 'ID',
				textField: 'IDDesc',
				onBeforeLoad: function (param) {
					param.ClassName = 'DHCMed.SSService.DiseaseSrv';
					param.QueryName = 'QryDisease';
					param.ResultSetType = 'array';
					param.aProductCode = 'FBD';
					param.aIsActive = 1;
					param.aCateID = CateID;
				}
			});
	    }
	});
	
	 //状态checkbox
   obj.chkStatus = function() {
	   	var strDicList =$m({
			ClassName:"DHCMed.FBDService.ReportSrv",
			MethodName:"GetDicForCheckGroup",
			aType:"FBDReportStatus",
			aActive:1
	 	},false);
	 	
	 	var dicList = strDicList.split(",");
		for (var dicIndex = 0; dicIndex < dicList.length; dicIndex++) {
			var dicSubList = dicList[dicIndex].split("^");
			$("#chkStatusList").append(
				 "<input id="+dicSubList[0]+" type='checkbox' class='hisui-checkbox' "+(dicSubList[0]==1? "checked='checked'":"")+" label="+dicSubList[1]+" name='chkStatus' value="+dicSubList[0]+">"
			);
		}
		$.parser.parse("#chkStatusList");  //解析checkbox
   }
   
	obj.GetStatus = function() {
	    var Status = "";
		$("input[name='chkStatus']:checked").each(function(){
		      Status = Status + $(this).val()+ ","; 
		});
		if (Status!="") { Status = Status.substring(0, Status.length-1); }
		return Status;
	}

   obj.gridFBDQuery = $HUI.datagrid("#FBDSusQuery",{
		fit: true,
		title:'疑似食源性疾病报告查询',
		headerCls:'panel-header-gray',
		iconCls:'icon-apply-check',
		pagination: true, //如果为true, 则在DataGrid控件底部显示分页工具栏
		rownumbers: true, //如果为true, 则显示一个行号列
		//singleSelect: true,
		autoRowHeight: false, //定义是否设置基于该行内容的行高度。设置为 false，则可以提高加载性能
		loadMsg:'数据加载中...',
		pageSize: 20,
		pageList : [20,50,100,200],
		columns:[[
			{field:'checkOrd',checkbox:'true',align:'center',width:30,auto:false},
			{field:'expander',title:'操作',width:45,align:'center',
				formatter: function(value,row,index){
					if (value=="") return "";
					var ReportID = row["ID"];
					var EpisodeID = row["EpisodeID"];
					if ((typeof HISUIStyleCode != 'undefined') && (HISUIStyleCode=="lite")){
						var btn = '<a href="#" class="icon icon-paper" onclick="objScreen.OpenFBDSusReport(\'' + ReportID + '\',\'' + EpisodeID + '\')"></a>';
					}else{
						var btn = '<a href="#" class="btn_detail" onclick="objScreen.OpenFBDSusReport(\'' + ReportID + '\',\'' + EpisodeID + '\')"></a>';
					}
					return btn;
				}
			}, 
			{field:'CardNo',title:'报告编号',width:'140'},
			{field:'StatusDesc',title:'报告状态',width:'80',
				 styler: function(value,row,index){
					var retStr = "", tmpStatusCode = row["StatusCode"];
					if (tmpStatusCode==1) {
						retStr =  'color:red;';
					} else if (tmpStatusCode==2) {
						retStr = 'color:green;';
					}else if (tmpStatusCode==3) {
						retStr = 'color:black;';
					} else if (tmpStatusCode==4) {
						retStr = 'color:blue;';
					} else if (tmpStatusCode==5) {
						retStr = 'color:gray;';
					} else {
						retStr = 'color:black;';
					} 
					return retStr;
				}
			}, 
			{field:'PapmiNo',title:'登记号',width:100},
			{field:'PatName',title:'姓名',width:80},
			{field:'Sex',title:'性别',width:60},
			{field:'PatAge',title:'年龄',width:50},
			{field:'AdmTypeDesc',title:'报告位置',width:80},
			{field:'CardTypeDesc',title:'证件类型',width:120},  
			{field:'Identify',title:'证件号',width:160},
			{field:'Contactor',title:'联系人',width:100},
			{field:'Telephone',title:'联系电话',width:120},
			{field:'FixedTel',title:'固定电话',width:100},
			{field:'RegAdd',title:'户籍地址',width:220},
			{field:'Address',title:'现住址',width:220},
			{field:'CateDesc',title:'疾病分类',width:140},
			{field:'DiseaseDesc',title:'疾病名称',width:160},
			{field:'DiseaseText',title:'疾病备注',width:180},
			{field:'LurkTime',title:'潜伏时间',width:120},
			{field:'OccupationDesc',title:'职业',width:100},
			{field:'ReasonDesc',title:'上报原因',width:120},
			{field:'IsInHospDesc',title:'是否<br>住院',width:50},
			{field:'SickDate',title:'发病日期',width:100},
			{field:'AdmitDate',title:'就诊日期',width:100},
			{field:'RepUserName',title:'报告人',width:80},	
			{field:'ReportDate',title:'报告日期',width:100},
			{field:'ReportTime',title:'报告时间',width:80},
			{field:'ChkUserName',title:'审核人',width:80},
			{field:'CheckDate',title:'审核日期',width:100},
			{field:'CheckTime',title:'审核时间',width:80},
			{field:'ReportLocDesc',title:'上报科室',width:120},
			{field:'PreDiagnosDrs',title:'初步诊断',width:120},
			{field:'SusCauseList',title:'可疑病因',width:120},
			{field:'MainSym',title:'主要症状',width:120},
			{field:'OtherSym',title:'其他症状',width:120},
			{field:'MainSign',title:'主要体征',width:120},
			{field:'SusAbFood',title:'可疑食品名称',width:120},
			{field:'TestResult',title:'实验室检查结果',width:120},
			{field:'TestAssist',title:'辅助检查结果',width:120}
		]],
		onDblClickRow:function(index, row) {
			if (index>-1) {
				obj.gridReport_rowdbclick();
			}
		},onLoadSuccess:function(data){
			//加载成功
			dispalyEasyUILoad(); //隐藏效果
			$('#FBDSusQuery').datagrid('unselectAll');//清除所有选中
		}
		
	});
  
	InitSusAbQueryWinEvent(obj);
	obj.LoadEvent(arguments);
		
	return obj;
}


