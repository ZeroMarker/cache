//页面Gui
var objScreen = new Object();

function InitBPSurvWin(){
	var obj = objScreen;
	obj.Params="";
	//管理员权限
	obj.AdminPower=0;
	if (tDHCMedMenuOper['Admin']==1) {
		obj.AdminPower =1;
	}
	
	///加载编号(加载编号[默认加载最近一条][显示]  管理员:可选,非管理员:不可选)
	$HUI.combobox("#cboSurvNumber",{
		url:$URL+'?ClassName=DHCHAI.IRS.BPSurveyExecSrv&QueryName=QueryByCode&ResultSetType=Array&aHospIDs='+$.LOGON.HOSPID+'&aFlag='+obj.AdminPower,
		valueField:'ID',
		textField:'SESurvNumber',
		onLoadSuccess:function(data){
			//默认选中最新一条
			$("#cboSurvNumber").combobox('select',data[0].ID);
			if(tDHCMedMenuOper['Admin']!=1) {
				$('#cboSurvNumber').combobox('disable');
			}
		}
	});
	$("#btnChkReps").hide();
	$("#btnUnChkReps").hide();
	$HUI.radio("input[name='chkStatunit']",{
		onChecked:function(e,value){
			var Status=Common_CheckboxValue('chkStatunit');
			if (Status=="2"){
				$("#btnChkReps").show();
				$("#btnUnChkReps").hide();
			}else if (Status=="3"){
				$("#btnUnChkReps").show();
				$("#btnChkReps").hide();
			}else{
				$("#btnChkReps").hide();
				$("#btnUnChkReps").hide();
			}
			obj.reloadgridBPReg();
		},
		onUnchecked:function(e,value){
			$("#btnChkReps").hide();
			$("#btnUnChkReps").hide();
			obj.reloadgridBPReg();
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
		},onLoadSuccess:function(data){
			// 院区默认选择
			$('#cboHospital').combobox('select',data[0].ID);
		}
	});
	
	if(tDHCMedMenuOper['Admin']!=1) {
		$("#cboBDLocation").combobox('setValue',$.LOGON.LOCID);
		$("#cboBDLocation").combobox('setText',$.LOGON.LOCDESC);
		$('#cboLocation').combobox('disable');
		$('#cboHospital').combobox('disable');
	}
	
	obj.gridBPRegList=$('#gridBPRegList').datagrid({
        fit:true,
        toolbar:'#ToolBar',
        headerCls:'panel-header-gray',
		iconCls:'icon-resort',
        pagination: true, //如果为true, 则在DataGrid控件底部显示分页工具栏
        rownumbers:false,
        singleSelect:false,
        autoRowHeight: false, //定义是否设置基于该行内容的行高度。设置为 false，则可以提高加载性能
		loadMsg:'数据加载中...',
		loading:true,
		//是否是服务器对数据排序
		sortOrder:'asc',
		remoteSort:false,
		//分页
		pageSize: 20,
		pageList : [20,50,100,500,1000,10000],
	    columns:[[
	    	{field:'checkOrd',checkbox:'true',width:'80',auto:false},
			{title:'调查状态',width:80,field:'RepStatus',
				formatter:function(value,row,index){
					var ReportID   = row["BPSurvID"];
					var SurvNumber = row["SurvNumberID"];
					var BPRegID    = row["BPRegID"];
					if (value=="未调查"){
						var RepStatus=1;
					}else if (value=="已调查"){
						var RepStatus=2;
					}else{
						var RepStatus=3;
					}
					 return '<a href="#" onclick="objScreen.OpenReport(\'' + SurvNumber + '\',\'' + ReportID+ '\',\''+ index+ '\',\'' + RepStatus+ '\',\'' + BPRegID + '\')">'+value+'</a>';
				}
			}, 
			{ field:"AdmLocDesc",title:"调查科室/病区",width:180,sortable:true},
			{ field:"PapmiNo",title:"登记号",width:100,sortable:true},
			{ field:"PAMrNo",title:"病案号",width:100,sortable:true},
			{ field:"PAPatName",title:"姓名",width:70,sortable:true},
			{ field:"PAPatSex",title:"性别",width:50,sortable:true},
			{ field:"PAPatAge",title:"年龄",width:50,sortable:true},
			{ field:"PARegDate",title:"登记日期",width:110,sortable:true},
			{ field:"PAStartDate",title:"首次透析日期",width:110,sortable:true},
			{ field:"PAHDTime",title:"透析次数",width:80,sortable:true},
			{ field:"PABPPatType",title:"病人类型",width:80,showTip:true,sortable:true},
			{ field:"BAccessType",title:"血管通路类型",width:120,sortable:true},
			{ field:"PAAdmDoc",title:"主管医生",width:80,sortable:true},
			{ field:"PAAdmNurse",title:"主管护士",width:80,showTip:true,sortable:true},
			{ field:"PAEpiInfo",title:"传染病类型",width:100,sortable:true},
			{ field:"PADiagnosis",title:"血透相关诊断",width:200,sortable:true},
			{ field:"BPRegDate",title:"报告日期",width:100,sortable:true},
			{ field:"BPRegLocDesc",title:"报告科室",width:80,sortable:true,sorter:Sort_int},
			{ field:"BPRegUserDesc",title:"报告人",width:100,sortable:true,sorter:Sort_int}
			]],
		onLoadSuccess:function(data){
			dispalyEasyUILoad(); //隐藏效果
		}
    });
	

	InitBPSurvWinEvent(obj);
	obj.LoadEvent(arguments);

	return obj;
}
