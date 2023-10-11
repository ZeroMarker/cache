/*
 * FileName:	dhcinsu.declaration.js
 * User:		tangzf
 * Date:		2020-02-27
 * Description: 医保申报
 */ 
 var GV = {
	UPDATEDATAID : '',
	HospDr:session['LOGON.HOSPID'] ,
	ADMID:'',
	PAPMI:'',
	INSUADMID : ''
}
 $(function () { 
 	window.onresize=function(){
    	location.reload();//页面进行刷新
 	} 
	// 医保类型
	init_INSUType();
	
	// 查询面板医保类型
	init_SearchINSUType();
	
	// 查询面板医疗类别
	init_SearchAdmType();
		
	// HIS卡类型
	initCardType();
	
	//卡号回车查询事件
	$("#HISCardNo").keydown(function (e) {
		cardNoKeydown(e);
	});
	
	//登记号回车查询事件
	$("#patientNo").keydown(function (e) {
		patientNoKeydown(e);
	});
	//审批编号回车查询事件
	$("#SearchRPTNo").keydown(function (e) {
		var key = websys_getKey(e);
		if (key == 13) {
			initLoadGrid();
		}
	});
	//人员编号回车查询事件
	$("#SearchPatNo").keydown(function (e) {
		var key = websys_getKey(e);
		if (key == 13) {
			initLoadGrid();
		}
	});
	// 就诊记录
	initAdmList();
	
	// 申报信息下拉框
	init_AddInfoPanel();
	
	// 医院项目名称
	init_HISTarItem();
		
	init_dg(); 
	
	init_layout();
	
	//转院备案导出 WangXQ 20220627
	$('#btnexport').bind('click', function () {
		Referexport_Click();
	});
	
	$('#HISCardType').combobox('disable',true);
	clear();
});
function initAdmList() {
	$HUI.combogrid("#AdmList", {
		panelWidth: 560,
		panelHeight: 200,
		striped: true,
		fitColumns: false,
		editable: false,
		pagination: true,
		pageSize: 100,
		pageList: [100],
		method: 'GET',
		idField: 'admId',
		textField: 'admNo',
		columns: [[{field: 'admNo', title: "就诊号", width: 100},
					{field: 'admStatus', title: '就诊类型', width: 80},
					{field: 'admDate', title: '就诊日期', width: 150,
						formatter: function (value, row, index) {
							if (value) {
								return value + " " + row.admTime;
							}
					}
					},
					{field: 'admDept', title: '就诊科室', width: 100},
					{field: 'admWard', title: '就诊病区', width: 120},
					{field: 'admBed', title: '床号', width: 60},

					{field: 'admId', title: '就诊ID', width: 80},
					{field: 'patName', title: '姓名', width: 80,hidden:true},
					{field: 'PaSex', title: '性别', width: 80,hidden:true},
					{field: 'PAPMIHealthFundNo', title: '医保手册号', width: 80,hidden:true}
			]],
		onLoadSuccess: function (data) {

		},
		onLoadError:function(e){
		},
		onSelect: function (index, row) {
			GV.ADMID = row.admId;
			refreshBar('',row.admId);
			var admReaStr = getAdmReasonInfo(row.admId);
			var admReaAry = admReaStr.split("^");
			var admReaId = admReaAry[0];
			var INSUType = GetInsuTypeCode(admReaId);
			$("#QInsuType").combobox('select', INSUType);
			GetInsuAdmInfo();
		 	setValueById('name',row.patName); //姓名
		 	setValueById('Sex',row.PaSex); //性别		
		}
	});
}


//获取医保就诊信息函数
function GetInsuAdmInfo()
{
	$.m({
		ClassName: "web.DHCINSUIPReg",
		MethodName: "GetInfoByAdm",
		type: "GET",
		itmjs: "",
		itmjsex: "",
		Paadm: GV.ADMID
	}, function (rtn) {
          if (typeof rtn != "string")
         {
	       $.messager.alert('提示','没有在His找到医保登记(挂号)信息','info');
	     }
		if (rtn.split("!")[0] != "1") {
			$.messager.alert('提示','没有在His找到医保登记(挂号)信息','info');
		} else {
			var myAry = rtn.split("!")[1].split("^");
			GV.INSUADMID =  myAry[0]
			//setValueById("InsuActiveFlag", actDesc);           //医保登记状态
			setValueById("PatNo", myAry[2]);               //医保号
			setValueById("INSUCardNo", myAry[3]);               //医保卡号
			//setValueById("NewCardNo", myAry[3]);            //新医保卡号
			//setValueById("OldCardNo", myAry[39]);           //旧医保卡号
			//InsuType=myAry[18];			
			//setValueById("InsuType",myAry[18])
			//InitYLLBCmb(myAry[14]);                          //医疗类别
		    //InitBCFSCmb();                                  //治疗方式
		    //InitZLFSCmb();                                   //补偿方式
			setValueById("rylb", myAry[4]);          //人员类别
			//$("#InsuInDiagDesc").combogrid("grid").datagrid("loadData", {
			//	total: 1,
			//	rows: [{"Code": myAry[26], "Desc": myAry[27]}]
			//});
			//$("#InsuInDiagDesc").combogrid("setValue", myAry[26]); 
			//setValueById("rylb", myAry[4]);          //人员类别  //医保诊断
			
			//setValueById("insuTreatType", myAry[36]);        //待遇类别
			//setValueById("insuAdmSeriNo", myAry[10]);        //医保就诊号
			//setValueById("xzlx",myAry[37])                   //险种类型
	        //setValueById("dylb",myAry[36])                   //待遇类别
	        //setValueById("AdmDate",myAry[12])                //入院日期
	        //setValueById("AdmTime",myAry[13])                //入院时间
            //setValueById("InsuAdmSeriNo",myAry[10])          //医保就诊号
            setValueById("States",myAry[8])              //医保统筹区
			//setValueById("ZLFS", myAry[38]);               //治疗方式
			//setValueById("BCFS", myAry[39]);               //补偿方式
		}
	});
	
}
// 加载就诊列表
function loadAdmList(myPapmiId) {
	$('#AdmList').combobox('clear');
	
	var queryParams = {
		ClassName: "web.INSUReport",
		QueryName: "FindAdmList",
		type: "GET",
		papmi: myPapmiId,
		hospId: PUBLIC_CONSTANT.SESSION.HOSPID
	}
	loadComboGridStore("AdmList", queryParams);
}
/**
* 登记号回车事件
*/
function patientNoKeydown(e) {
	var key = websys_getKey(e);
	if (key == 13) {
		getPatInfo();
	}
}
function init_layout(){	
	// east-panel
	var bodyWidth = +$('body div:first').css('width').split('px')[0];
	var westWidth = '800';
	var eastWidth = bodyWidth - westWidth;  	
	$('.west-panel').panel({ 
		width:westWidth 
	});  
	$('.west-panel').panel('resize');
	// east
	$('.east-panel').panel({
		width:eastWidth,
	});
	$('.east-panel').panel('resize');
	$('.layout-panel-east').css('left' ,westWidth + 'px'); 
	
	$('.EastSearch').panel({
		width:100	
	});
	$('.EastSearch').panel('resize');

	var dgHeight = window.document.body.offsetHeight - 36 - 20 - 12 - 122; // // window - patbanner - padding(banner)10 - padding(panel)10*2 - 查询面板
	var height = dgHeight + 124 -126
	//$('#dg').datagrid('options').height = dgHeight;
	//$('#dg').datagrid('resize');
	$('#ReportPanel').panel('options').height = height;
	$('#ReportPanel').panel('resize');
	
}
/*
 * 医保类型 和医保类型有关的 下拉框需要在这重新加载
 */
function init_INSUType(){
	var Options = {
		defaultFlag:'Y'	,
		hospDr:GV.HospDr
	}
	INSULoadDicData('QInsuType','DLLType',Options); 	
	$('#QInsuType').combobox({
		onSelect:function(){
			$('#rylb').combobox('clear');
			$('#States').combobox('clear');
			$('#DiagCodeMXB').combobox('clear');
			$('#AdmType').combobox('clear');
			//reload
			$('#rylb').combobox('reload');
			$('#States').combobox('reload');
			$('#DiagCodeMXB').combobox('reload');
			$('#AdmType').combobox('reload');
			$('#Insutype').combobox('reload');
		}	
	})	
}
function init_SearchINSUType(){
var Options = {
		defaultFlag:'Y'	,
		hospDr:GV.HospDr
	}
	INSULoadDicData('SearchInsuType','DLLType',Options); 
	$('#SearchInsuType').combobox({
		onSelect:function(){
			$('#SearchAdmType').combobox('clear');
			$('#SearchAdmType').combobox('reload');
		}	
	})	
}
/*
 * 审批类别
 */
function init_SearchAdmType(){
	$HUI.combobox(('#SearchAdmType'),{
		defaultFilter:'4',
		valueField: 'cCode',
		textField: 'cDesc',
		loadFilter:function(data){
	        data.splice(data.length - 1, 1); // 把query返回的 全部 去掉
	        return data;
		},
		url:$URL,
		onBeforeLoad:function(param){
			param.ClassName = 'web.INSUDicDataCom';
			param.QueryName= 'QueryDic';
			param.Type = 'med_type' + getValueById('SearchInsuType');
			param.Code = '';
			param.HospDr = GV.HospDr; 
			param.ResultSetType = 'array';
		},
		onLoadSuccess:function(data){
			
		}		
	});
	$HUI.combobox(('#AdmType'),{
		defaultFilter:'4',
		valueField: 'cCode',
		textField: 'cDesc',
		editable:false,
		url:$URL,
		loadFilter:function(data){
	        data.splice(data.length - 1, 1); // 把query返回的 全部 去掉
	        return data;
		},
		onBeforeLoad:function(param){
			param.ClassName = 'web.INSUDicDataCom';
			param.QueryName= 'QueryDic';
			param.Type = 'med_type' + getValueById('QInsuType');
			param.Code = '';
			param.HospDr = GV.HospDr; 
			param.ResultSetType = 'array';
		},
		onLoadSuccess:function(data){

		}		
	});
}
/*
 * datagrid
 */
function init_dg() {
	var dgColumns = [[
			{field:'TabRptTypeDesc',title:'审批类别',width:75},
			{field:'TabFlag',title:'审批标志',width:80,styler:function(val, index, rowData){
				switch (val){
					case "审批未通过":
						return "background:red";
						break;
					case "审批通过":
						return "background:green";
						break;
					case "未审批":
						return "background:yellow";
						break;			
				}
			}},	
			{field:'TabINSUType',title:'医保类型',width:75},
			{field:'TabRptDate',title:'申报日期',width:100},
			{field:'TabSDate',title:'有效开始日期',width:100},
			{field:'TabEDate',title:'有效结束日期',width:100},
			{field:'TabAdmSeriNo',title:'住院流水号',width:150},
			{field:'TabPatNo',title:'个人编号',width:150 },
			{field:'TabPatName',title:'患者姓名',width:150 },
			{field:'TabAdmType',title:'就诊类型',width:120},
			{field:'TabDiagCode',title:'疾病编码',width:150 },
			{field:'TabDiagDesc',title:'疾病名称',width:150},
			{field:'TabRPTNo',title:'审批编号',width:150},
			{field:'Tabxmbm',title:'项目编码',width:150},
			{field:'Tabxmmc',title:'项目名称',width:150 },
			{field:'TabHisCode',title:'医院项目编码',width:150,hidden:true},
			{field:'TabHisDesc',title:'医院项目名称',width:150,hidden:true },
			{field:'Tabxmlb',title:'项目类别',width:150 },
			{field:'TabOutHosName',title:'转外医院',width:150 },
			{field:'Tabmoney',title:'金额',width:150,align:'right' },
			{field:'Tabsl',title:'数量',width:150 },
			{field:'TabUserName',title:'申报人',width:150 },
			{field:'TabDoctor',title:'主治医生',width:150 },
			{field:'TabNumberID',title:'审批批次号',width:150 },
			{field:'TabStates',title:'参保地',width:150 },
			{field:'TabHosYJ',title:'医院意见',width:150 },
			{field:'TabJSYJ',title:'家属意见',width:150 },
			{field:'TabMD',title:'	目的',width:150 },
			{field:'TabZZ',title:'症状',width:150 },	
			{field:'TabBZ',title:'备注',width:150 },
			{field:'TabRptType',hidden:true },	
			{field:'rowid',hidden:true}
		]];

	// 初始化DataGrid
	$('#dg').datagrid({
		fit:true,
		border: false,
		striped: true,
		singleSelect: true,
		pagination: true,
		rownumbers: false,
		pageSize: 20,
		pageList: [20, 30, 40, 50],
		columns: dgColumns,
		toolbar: '#tToolBar',
		onDblClickRow:function(index,rowData){
			//FindReportInfo();	
		}
	});
}
/*
 * 加载数据
 */
function initLoadGrid(){
	if(getValueById('SearchInsuType')==''){
		//$.messager.alert('提示','医保类型不能为空','info');
		//return;	
	}
	var ExpStr = getValueById('SearchRPTNo') + '|' + getValueById('SearchPatNo');
    var queryParams = {
	    ClassName : 'web.INSUReport',
	    QueryName : 'QueryAll',
	    SearchAdmType : getValueById('SearchAdmType'),
	    StartDate : getValueById('StartDate'),
	    EndDate : getValueById('EndDate'),
	    HospId: GV.HospDr,
	    ParamINSUType: getValueById('SearchInsuType'),
	    ExpStr:ExpStr
	}	
    loadDataGridStore('dg',queryParams);
}
/*
 * 查询医保审核信息
 */
$('#btnFindReport').bind('click', function () {
	FindReportInfo();
})
/*
 * readcard
 */
$('#btn-readINSUCard').bind('click', function () {
	if(getValueById('QInsuType')==''){
		$.messager.alert('提示', "医保类型不能为空" + str, 'error');	
		return;	
	}
	var CardType="1",InsuNo="";
	var ExpString = getValueById('QInsuType') + '^' + GV.HospDr;
	var UserId = session['LOGON.USERID'];
	var str = InsuReadCard('0',UserId,InsuNo,1,ExpString);
	var TmpData = str.split("|");
	if (TmpData[0]!="0"){
		$.messager.alert('提示', "读卡失败" + str, 'error');	
		return;
	}else{
	 	var TmpData1 = TmpData[1].split("^")
	 	var TmpData2 = TmpData[2].split("^")
	 	setValueById('PatNo',TmpData1[0]); //个人编号
	 	setValueById('INSUCardNo',TmpData1[1]);  //卡号
	 	setValueById('name',TmpData1[3]); //姓名
	 	setValueById('Sex',TmpData1[4]); //性别
	 	//setValueById('States',TmpData2[8]); //参保人所属地
	 	setValueById('States',TmpData[6]); //参保人所属地
	 	setValueById('rylb',TmpData1[11]);  //人员类别
	 	
	 	setValueById('Insutype',TmpData[3]);  //险种类型	 	
	 }
});
/**
* 数据校验
*/
function checkData() {
	var inValiddatebox = $('.validatebox-invalid');
	if(inValiddatebox.length > 0){ //validdatebox
		$.each(inValiddatebox, function (index, rowData) {
			var labelDesc = $('#' + rowData.id).parent().prev().find('label').text();
			var clsStr = $('#' + rowData.id).attr('class');
			if(clsStr.indexOf('combobox') > 0){
				var vaildCheck = getValueById(rowData.id);
				if(vaildCheck ==''>0){
					$.messager.alert('提示', '[' + labelDesc +']' + '验证不通过' , 'error');
					throw rowData.id;
				}
			}else{
				$.messager.alert('提示', '[' + labelDesc +']' + '验证不通过' , 'error');
				throw rowData.id;
			}
		});		
	}
}
/*
 * 保存
 */
$('#btnReport').bind('click', function () {
	try{

		checkData();
		var PatNo = getValueById('PatNo');
		var Name=getValueById('name');
		var AdmType = getValueById('AdmType');
		var AdmSeriNo = '';
		var OutHosName = '';
		var HosLevel = '';
		var DiagCode = getValueById('DiagCode');
		var DiagDesc = $('#DiagCode').combobox('getText');
		var HosYJ = getValueById('HosYJ');
		var xmbm = getValueById('xmbm');
		var xmmc = $('#xmbm').combobox('getText');	
		var sl = getValueById('sl');
		var RptDate = getValueById('RptDate');	
		var SDate = getValueById('SDate');	
		var EDate = getValueById('EDate');	
		var Guser = session['LOGON.USERID'];
		var OutHosName = '';
		var GuserName = session['LOGON.USERNAME'];
		var OutType = '';
		var Demo = '';
		var money = getValueById('money');
		var xmlb = '';
		var RPTNo = '';
		var ZYZZ = getValueById('ZYZZ');
		var MD = getValueById('MD');
		var Doctor = getValueById('Doctor');
		var DoctorCode=getValueById('DoctorCode');
		var KZR = getValueById('KZR');
		var JSYJ = getValueById('JSYJ');
		var KZRYJ = getValueById('KZRYJ');
		var LRuser = '';
		var LRDate = '';
		var RPTUser = '';
		var HisCode = '';
		var HisDesc = '';
		var NumberID = '';
		var States =  $('#States').combobox('getText'); 
		var HospId = GV.HospDr;
		
		var insutype=getValueById('Insutype');
		var HiType=getValueById('QInsuType');
        /*
                    //0                       											5															11									14
		var str = PatNo + "|"+RptType+"|"+AdmSeriNo+"|"+OutHosName+"|"+HosLevel+"|"+DiagCode+"|"+DiagDesc+"|"+HosYJ+"|"+xmbm+"|"+xmmc+"|"+sl+"|"+RptDate+"|"+SDate+"|"+EDate+"|"+GuserName+"|";
		//				15												20																			28			
		str = str + OutType+"|"+Demo+"|"+money+"|"+xmlb+"|"+RPTNo+"|"+ZYZZ+"|"+MD+"|"+Doctor+"|"+KZR+"|"+JSYJ+"|"+KZRYJ+"|"+LRuser+"|"+LRDate+"|"+RPTUser+"|";
								// 30								      33			34就诊ID
		str = str + HisCode+"|"+HisDesc+"|"+AdmType+"|"+NumberID + "|" + States + "|" + GV.ADMID + "|" + GV.INSUADMID;
		ExpString = getValueById('QInsuType') + '^^' +getValueById('name'); // insutype^ExpStrForNet^Name
		var rtn=InsuReport(0,Guser,str,ExpString);
		*/
		
		//^^^人员编号^人员姓名^备案类型(审批类别,区分不同业务审批备案)^^备案日期^^医疗类别（可为空）^门慢特病病种编码^
		//门慢特病病种名称^开始日期^结束日期（可为空）^^^^^^^^^^^^^^^^^^^参保区划^^^^^^^
		//联系电话^^^鉴定机构编码(可为空)^鉴定机构名称（可为空）^诊断医师编码^诊断医师名称^^^险种类型^联系地址^
		var str =HiType+"^"+""+"^"+""+"^"+ PatNo +"^"+ Name +"^"+"01"+"^"+""+"^"+RptDate+"^"+""+"^"+AdmType+"^"+DiagCode+"^"+DiagDesc+"^"+SDate+"^"+EDate
		var str=str+"^^^^^^^^^^^^^^^^^^^"+States+"^^^^^^^"
		var str=str+"^"+""+"^^^"+""+"^"+DoctorCode+"^"+Doctor+"^^^"+insutype+"^"+""+"^"
		var ExpString = getValueById('QInsuType') + '^^' +getValueById('name'); // insutype^ExpStrForNet^Name
		var rtn=InsuReport(0,Guser,str,ExpString);
		if (rtn == 0){
			$.messager.alert('提示', "审批上报成功!", 'info',function(){
				$HUI.dialog("#LocalListInfoProWin",'close');
				clear();
				initLoadGrid();	
			});	
		} else{
			$.messager.alert('错误', "审批上报失败!：" + rtn, 'error');
		}
	}catch(e){
	}
});
/*
 * 删除
 */
$('#btnDel').bind('click', function () {
	var selected = $('#dg').datagrid('getSelected');
	if (selected) {
		if(selected.TabFlag == '已撤销'){
			$.messager.alert('提示','该记录已撤销','info');	
			return;
		}
		if (selected.rowid != "") {
			$.messager.confirm('确认', '确认撤销上报记录？', function (r) {
				if (r) {
					var str=selected.TabRptType + "|"  + selected.TabPatNo + "|" + selected.TabAdmSeriNo + "|" + selected.TabDiagCode + "|" + selected.TabDiagDesc + "|" + selected.TabSDate
					var ExpString = getValueById('SearchInsuType') + '^^^'; // insutype^ExpStrForNet
					//var rtn=tkMakeServerCall("web.INSUReport", "DeleteReport", selected.rowid); //DHCINSUBLL.InsuReportDestroy(1,str,Guser,ExpString);	
					var rtn=InsuReportDestory(1,session['LOGON.USERID'],selected.rowid,str,ExpString);	
				    if (rtn!="0"){
					    $.messager.alert('错误', "审批上报撤销失败!" + rtn, 'info');
					}else {
						$.messager.alert('错误', "审批上报撤销成功!", 'info',function(){
							initLoadGrid();	
						});
				    }
				}
			});
		}
	} else {
		$.messager.alert('提示', "请选择要撤销的记录", 'info');
	}
});
/*
 * 备案查询
 */
$('#btnSearch').bind('click', function () {
	var selected = $('#dg').datagrid('getSelected');    
	if (selected) { 
		if (selected.rowid != "") {                                      //查单条
		 	var RptType = "01";
			$.messager.confirm('确认', '确认查询该条备案记录？', function (r) {
				if (r) {
					var str=selected.TabRptType + "|"  + selected.TabPatNo + "|" + selected.TabAdmSeriNo + "|" + selected.TabDiagCode + "|" + selected.TabDiagDesc + "|" + selected.TabSDate
					 
					var rtn=InsuReportQuery(1,"","",session['LOGON.USERID'],selected.rowid,RptType,getValueById('INSUType'))	
				    if (rtn!="0"){
					    $.messager.alert('错误', "备案查询失败!" + rtn, 'info');
					}else {
						$.messager.alert('错误', "备案查询成功!" + rtn, 'info',function(){
							initLoadGrid();	
						});
				    }
				}
			});
		}
	} else {                                                           //查所有
		 var SDate = GetInsuDateFormat(getValueById('StartDate'));	
		 var EDate = GetInsuDateFormat(getValueById('EndDate'));	
		 var RptType = "01";
	     var rtn=InsuReportQuery(1,SDate,EDate,session['LOGON.USERID'],"",RptType,getValueById('INSUType'))	                                                
		 if (rtn!="0"){
			 $.messager.alert('错误', "备案查询失败!" + rtn, 'info');
					}else {
						$.messager.alert('错误', "备案查询成功!" + rtn, 'info',function(){
							initLoadGrid();	
						});
				    }
				    
	}
});
/*
 * 查询
 */
$('#btnFind').bind('click', function () {
	initLoadGrid();
});


/* 
 * 查询医保审核信息
 */
function FindReportInfo(){
	var selected = $('#dg').datagrid('getSelected');
	if (selected) {
		if(selected.TabFlag =='已撤销'){
			$.messager.alert('提示', "审核已经撤销", 'info');
			return;
		}
		$.messager.alert('提示', "需要连接医保中心", 'info');	
	} else {
		$.messager.alert('提示', "请选择要查询的记录", 'info');
	}
}
/* 
 * 初始化申报面板
 */
function init_AddInfoPanel(){
	

	/*
	// 审批类别
	$HUI.combobox(('#RptType'),{
		defaultFilter:'4',
		valueField: 'cCode',
		textField: 'cDesc',
		loadFilter:function(data){
	        data.splice(data.length - 1, 1); // 把query返回的 全部 去掉
	        return data;
		},
		url:$URL,
		onBeforeLoad:function(param){
			param.ClassName = 'web.INSUDicDataCom';
			param.QueryName= 'QueryDic';
			param.Type = 'med_type' + getValueById('QInsuType');
			param.Code = '';
			param.HospDr = GV.HospDr; 
			param.ResultSetType = 'array';
		},
		onLoadSuccess:function(data){

		}		
	});
	*/
	// 人员类别
	$HUI.combobox(('#rylb'),{
		defaultFilter:'4',
		valueField: 'cCode',
		textField: 'cDesc',
		url:$URL,
		loadFilter:function(data){
	        data.splice(data.length - 1, 1); // 把query返回的 全部 去掉
	        return data;
		},
		onBeforeLoad:function(param){
			param.ClassName = 'web.INSUDicDataCom';
			param.QueryName= 'QueryDic';
			param.Type = 'AKC021' + getValueById('QInsuType');
			param.Code = '';
			param.HospDr = GV.HospDr; 
			param.ResultSetType = 'array';
		},
		onLoadSuccess:function(data){

		}		
	})
	
	// states
	$HUI.combobox(('#States'),{
		defaultFilter:'4',
		valueField: 'cCode',
		textField: 'cDesc',
		url:$URL,
		loadFilter:function(data){
	        data.splice(data.length - 1, 1); // 把query返回的 全部 去掉
	        return data;
		},
		onBeforeLoad:function(param){
			param.ClassName = 'web.INSUDicDataCom';
			param.QueryName= 'QueryDic';
			param.Type = 'YAB003' + getValueById('QInsuType');
			param.Code = '';
			param.HospDr = GV.HospDr; 
			param.ResultSetType = 'array';
		},
		onLoadSuccess:function(data){

		}		
	});
	


	// 慢性病诊断
	$HUI.combobox(('#DiagCodeMXB'),{
		defaultFilter:'4',
		valueField: 'cCode',
		textField: 'cDesc',
		url:$URL,
		loadFilter:function(data){
	        data.splice(data.length - 1, 1); // 把query返回的 全部 去掉
	        return data;
		},
		onBeforeLoad:function(param){
			param.ClassName = 'web.INSUDicDataCom';
			param.QueryName= 'QueryDic';
			param.Type = 'Skc516' + getValueById('QInsuType');
			param.Code = '';
			param.HospDr = GV.HospDr; 
			param.ResultSetType = 'array';
		},
		onLoadSuccess:function(data){

		}		
	})
	
	// HIS诊断
	$HUI.combobox(('#DiagCode'),{
		defaultFilter:'3',
		valueField: 'code',
		textField: 'desc',
		url:$URL,
		mode:'remote',
		onBeforeLoad:function(param){
			if(param.q==''){
				return true;	
			}
			param.ClassName = 'web.DHCMRDiagnos';
			param.QueryName= 'LookUpWithAlias';
			param.desc = param.q;
			param.ResultSetType = 'array';
		},
		onLoadSuccess:function(data){

		}		
	});
	
	// 意见
	$('.advise').combobox({
		valueField: 'id',
		textField: 'text',
		editable: false,
		data:[{
    			"id" : '01',
    			"text":"同意",
    			selected:true
    		},{
    			"id" : '02',
    			"text":"不同意"	
    		}]	
	});
	// sex
	$('#Sex').combobox({
		valueField: 'Id',
		textField: 'Desc',
		url:$URL,
		editable: false,
		onBeforeLoad:function(param){
			param.ClassName = 'web.INSUReport';
			param.QueryName= 'FindCTSex';
			param.ResultSetType = 'array';
		},onLoadSuccess:function(data){
		},onLoadError:function(){
		}	
	});
	
	// 科主任
	$('#KZR').combobox({
		valueField: 'Desc',
		textField: 'Desc',
		url:$URL,
		defaultFilter:'4',
		onBeforeLoad:function(param){
			param.ClassName = 'web.INSUReport';
			param.QueryName= 'FindSSUser';
			param.ResultSetType = 'array';
			param.HospId = GV.HospDr;
		},onLoadSuccess:function(data){
		},onLoadError:function(){
		}	
	});
	
/*
 * 险种类型
 */
	$('#Insutype').combobox({
		defaultFilter:'4',
		valueField: 'cCode',
		textField: 'cDesc',
		loadFilter:function(data){
	        data.splice(data.length - 1, 1); // 把query返回的 全部 去掉
	        return data;
		},
		url:$URL,
		onBeforeLoad:function(param){
			param.ClassName = 'web.INSUDicDataCom';
			param.QueryName= 'QueryDic';
			param.Type = 'insutype' + getValueById('QInsuType');
			param.Code = '';
			param.HospDr = GV.HospDr; 
			param.ResultSetType = 'array';
		},
		onLoadSuccess:function(data){
			
		}		
	});
	
//	$('#Doctor').combobox({
//		valueField: 'Desc',
//		textField: 'Desc',
//		url:$URL,
//		defaultFilter:'4',
//		onBeforeLoad:function(param){
//			param.ClassName = 'web.INSUReport';
//			param.QueryName= 'FindSSUser';
//			param.ResultSetType = 'array';
//			param.HospId = GV.HospDr;
//		},onLoadSuccess:function(data){
//		},onLoadError:function(){
//		}	
//	});
// 医师
	$("#Doctor").combogrid({
		panelWidth: 320,
		panelHeight: 450,
		//delay:300,
		mode:'remote',
		method: 'GET',
		striped: true,
		fitColumns: true,
		pagination:true,
		editable: true,
		valueField: 'name',
		textField: 'code',
		url:$URL,
		
		data:[],
		columns:[
		[{
			field:'rowid',title:'rowid',hidden:true},
			{field:'code',title:'名称',width:100} ,
			{field:'name',title:'编码',width:100}
			
		]],
		onBeforeLoad:function(param){
		
			param.ClassName = "INSU.COM.BaseData";
			param.QueryName= "CTCareQuery";
			param.Name = param.q;
			param.HospId = GV.HospDr; //20210907 DingSH 
		},
		onLoadSuccess:function(data){
		 
		},
		onSelect:function(index,rowData){
			 
			//setValueById('DoctorCode',rowData.name)
			setValueById('DoctorCode',rowData.name)
			
			}	
	});
}
function getPatInfo() {
	var patientNo = getValueById("patientNo");
	if (patientNo) {
		var expStr = "";
		$.m({
			ClassName: "web.DHCOPCashierIF",
			MethodName: "GetPAPMIByNo",
			PAPMINo: patientNo,
			ExpStr: expStr
		}, function(papmi) {
			if (!papmi) {
				$.messager.popover({msg: "登记号错误，请重新输入", type: "info"});
				return;
				//focusById("patientNo");
			}
			var admStr = "";
			setPatientInfo(papmi);
			loadAdmList(papmi);
			refreshBar(papmi,'');
		});
	}
}

function setPatientInfo(papmi) {
	var expStr = PUBLIC_CONSTANT.SESSION.HOSPID;
	$.m({
		ClassName: "web.DHCOPCashierIF",
		MethodName: "GetPatientByRowId",
		PAPMI: papmi,
		ExpStr: expStr
	}, function(rtn) {
		var myAry = rtn.split("^");
		setValueById("patientNo", myAry[1]);
	});
}

/*

function getPatInfo() {
	var patientNo = "";
	var medicareNo = "";
	var episodeId = "";
	patientNo = getValueById("patientNo");
	if (patientNo || medicareNo || episodeId) {
		$.m({
			ClassName: "web.DHCIPBillCashier",
			MethodName: "GetAdmInfo",
			PatientNo: patientNo,
			MedicareNo: '',
			EpisodeID: episodeId,
			SessionStr: getSessionStr()
		}, function (rtn) {
			if (rtn) {
				setPatInfo(rtn);
			}else {
				$.messager.popover({msg: "患者不存在", type: "info"});
			}
		});
	}
}*/

/**
 * 刷新患者信息条
 */
function refreshBar(papmi, adm) {
	//loadAdmList(papmi);
	$.m({
		ClassName: "web.DHCDoc.OP.AjaxInterface",
		MethodName: "GetOPInfoBar",
		CONTEXT: "",
		EpisodeID: adm,
		PatientID: papmi
	}, function (html) {
		if (html != "") {
			$(".PatInfoItem").html(reservedToHtml(html));
		} else {
			$(".PatInfoItem").html("获取患者信息失败，请检查【患者信息展示】配置。");
		}
	});
}

function reservedToHtml(str) {
	var replacements = {
		"&lt;": "<",
		"&#60;": "<",
		"&gt;": ">",
		"&#62;": ">",
		"&quot;": "\"",
		"&#34;": "\"",
		"&apos;": "'",
		"&#39;": "'",
		"&amp;": "&",
		"&#38;": "&"
	};
	return str.replace(/(&lt;)|(&gt;)|(&quot;)|(&apos;)|(&amp;)|(&#60;)|(&#62;)|(&#34;)|(&#39;)|(&#38;)/g, function (v) {
		return replacements[v];
	});
}

/**
* banner提示信息
*/
function showBannerTip() {
	$(".PatInfoItem").html("<div class='unman'></div><div class='tip-txt'>请先查询患者</div>");
}
/**
* 初始化卡类型
*/
function initCardType() {
	$HUI.combobox("#HISCardType", {
		url: $URL + "?ClassName=web.INSUReport&QueryName=QCardTypeDefineList&ResultSetType=array",
		editable: false,
		valueField: "myTypeID",
		textField: "caption",
		onChange: function (newValue, oldValue) {
		},
		onLoadSuccess:function(){
			setValueById('HISCardType','');	
		}
	});
}


function cardNoKeydown(e) {
	var key = websys_getKey(e);
	if (key == 13) {
		//clear();
		var cardNo = getValueById("HISCardNo");
		if (!cardNo) {
			return;
		}
		DHCACC_GetAccInfo("", cardNo, "", "", magCardCallback);
	}
}

function magCardCallback(rtnValue) {
	loadAdmList('');
	var patientId = "";
	var myAry = rtnValue.split("^");
	switch (myAry[0]) {
	case "0":
		setValueById("HISCardNo", myAry[1]);
		patientId = myAry[4];
		setValueById("patientNo", myAry[5]);
		setValueById("HISCardType", myAry[8]);
		getPatInfo();
		break;
	case "-200":
		$.messager.alert("提示", "卡无效", "info", function () {
			//focusById("HISCardNo");
		});
		break;
	case "-201":
		setValueById("HISCardNo", myAry[1]);
		patientId = myAry[4];
		setValueById("patientNo", myAry[5]);
		setValueById("HISCardType", myAry[8]);
		getPatInfo();
		break;
	default:
	}
	if (patientId != "") {
		var admStr = "";
		loadAdmList(patientId);
		refreshBar(patientId, '');
	}
}

/**
* 获取就诊费别信息
*/
function getAdmReasonInfo(episodeId) {
	return $.m({ClassName: "web.UDHCJFPAY", MethodName: "GetAdmReaNationCode", EpisodeID: episodeId}, false);
}
// HIS收费项目
function init_HISTarItem(){		
	$('#xmbm').combobox({
		valueField: 'code',
		textField: 'desc',
		url: $URL + '?ClassName=DHCBILLConfig.DHCBILLFIND&QueryName=FindTarItem&ResultSetType=array',
		mode: 'remote',
		method: 'get',
		onBeforeLoad: function (param) {
			if (!param.q) {
				return false;
			}
			$.extend(param, {
				code: "",                           //项目代码
				desc: "",                           //项目名称 根据输入数据查询
				alias: param.q,                     //别名
				str: '',                //入参串
				HospID: GV.HospDr    //医院ID
			});
			return true;
	 	}
	});
}
$('#btnClean').bind('click',function(){
	clear();		
})
$('#btn-readCard').bind('click',function(){
	readHFMagCardClick();		
})

/**
 * 读卡
 * @method readHFMagCardClick
 * @author ZhYW
 */
function readHFMagCardClick() {
	if ($("#btn-readCard").hasClass("l-btn-disabled")) {
		return;
	}
	DHCACC_GetAccInfo7(magCardCallback);
}
function clear(){
	//查询区域
	$(".searchPanel").form("clear");
	$('#SearchInsuType').combobox('reload');
	//initLoadGrid();
	//
	$(".addInfo").form("clear");
	$('#QInsuType').combobox('reload');		
	$('.advise').combobox('select','01');
	// 数量，金额
	setValueById('money','0');
	setValueById('sl','0');
	$(".PatInfoItem").html('');
//	setValueById('SDate',getDefStDate(0));
//	setValueById('EDate',getDefStDate(1));
//	setValueById('RptDate',getDefStDate(0));
//	setValueById('StartDate',getDefStDate(0));
//	setValueById('EndDate',getDefStDate(1));
	
	InsuDateDefault('SDate');
	InsuDateDefault('EDate',1);
	InsuDateDefault('RptDate');
	InsuDateDefault('StartDate');
	InsuDateDefault('EndDate',1);
	ClearGrid('dg');
	//清除combogrid下拉框里面的数据 addby LuJH 20230412
	$(".combogrid-f").combogrid("clear").combogrid("grid").datagrid("loadData", { 
		total: 0,
		rows: []
	});
			
}

//慢特病申报记录导出  WangXQ  20220627
function Referexport_Click()
{
	try
   {
	var ExpStr = getValueById('SearchRPTNo') + '|' + getValueById('SearchPatNo');
$.messager.progress({
         title: "提示",
		 msg: '正在导出记录',
		 text: '导出中....'
		   });

$cm({
	ResultSetType:"ExcelPlugin",  
	ExcelName:"人员慢特病申报记录",		  
	PageName:"QueryAll",     
	ClassName:"web.INSUReport",
	QueryName:"QueryAll",
    SearchAdmType : getValueById('SearchAdmType'),
	StartDate : getValueById('StartDate'),
	EndDate : getValueById('EndDate'),
	HospId: GV.HospDr,
	ParamINSUType: getValueById('SearchInsuType'),
	ExpStr:ExpStr
},
function(){

	  setTimeout('$.messager.progress("close");', 3 * 1000);	
});
   
   } catch(e) {
	   $.messager.alert("警告",e.message);
	   $.messager.progress('close');
   };	
}

/*
*清空dg信息
*HanZH 20230328
*/	
function ClearGrid(gridid){
	$('#' + gridid).datagrid('loadData',{total:0,rows:[]});
}

