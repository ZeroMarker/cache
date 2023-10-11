/*
 * FileName:	dhcinsu.insudeclaration.js
 * User:		tangzf
 * Date:		2020-02-27
 * Description: 医保申报
 */
 var GV = {
	UPDATEDATAID : '',
	HospDr:session['LOGON.HOSPID'] 
}
 $(function () { 
 	$(document).keydown(function(e){
	 	banBackSpace(e);
	 	});
	setValueById('StartDate',getDefStDate(0));
	setValueById('EndDate',getDefStDate(1));
	
	
	// 审批类别
	init_ReportType();
	// 医保类型
	init_INSUType();	
	
	
	// 回车事件
	$('#search .textbox').keydown(function (e) {
		if (e.keyCode == 13) {
			initLoadGrid();
		}
	});
	
	$HUI.radio("[name='RptSt']",{
        onChecked:function(e,value){
           initLoadGrid();
        }
    });
	$('#PatName').keydown(function (e) {
		if (e.keyCode == 13) {
			initLoadGrid();
		}
	});
	init_dg(); 
});
/*
 * 医保类型
 */
function init_INSUType(){
	var Options = {
		defaultFlag:'N'	,
		hospDr:GV.HospDr
	}
	INSULoadDicData('INSUType','DLLType',Options); 	
	$('#INSUType').combobox({
		onSelect:function(){
			init_ReportType();
			// 加载就诊凭证类型
			init_CertType();
		}	
	})
}

/*
 * 就诊凭证类型
 */
function init_CertType(){
	var Options = {
		defaultFlag:'N',
		editable:'Y',
		hospDr:GV.HospDr	
	}
	INSULoadDicData('certtype','mdtrt_cert_type' + getValueById('INSUType'),Options); 	
}



/*
 * 审批类别
 */
function init_ReportType(){
	var Options = {
		defaultFlag:'N',
		editable:'Y',
		hospDr:GV.HospDr	
	}
	INSULoadDicData('Rptlb','RTPType' + getValueById('INSUType'),Options); 	
}
/*
 * datagrid
 */
function init_dg() {
	var dgColumns = [[
			{field:'TabPatNo',title:'个人编号',width:180 },
			{field:'TabPatName',title:'患者姓名',width:100 },
			{field:'TabRptDate',title:'申报日期',width:120},
			{field:'TabSDate',title:'有效开始日期',width:120},
			{field:'TabEDate',title:'有效结束日期',width:120},
			{field:'TabFlag',title:'审批状态',width:120,styler:function(val, index, rowData){
				switch (val){
					case "审批未通过":
						return "background:red"
						break;
					case "审批通过":
						return "background:green"
						break
					case "未审批":
						return "background:yellow"
						break
						
				}
			
			}},	
			{field:'TabDiagCode',title:'疾病编码',width:130 },
			{field:'TabDiagDesc',title:'疾病名称',width:180},
			{field:'TabRptType',title:'申报类型	',width:150},
			{field:'TabAdmType',title:'就诊类型',width:120,},
			{field:'TabRPTNo',title:'审批编号',width:220},
			{field:'Tabxmbm',title:'项目编码',width:150},
			{field:'Tabxmmc',title:'项目名称',width:150 },
			{field:'TabHisCode',title:'医院项目编码',width:150},
			{field:'TabHisDesc',title:'医院项目名称',width:150 },
			{field:'Tabxmlb',title:'项目类别',width:150 },
			{field:'TabOutHosName',title:'转外医院',width:150 },
			{field:'Tabmoney',title:'金额',width:150,align:'right' },
			{field:'Tabsl',title:'数量',width:150 },
			{field:'TabUserName',title:'经办人',width:150 },
			{field:'TabDoctor',title:'主治医生',width:150 },
			{field:'TabNumberID',title:'审批批次号',width:150 },
			{field:'TabStates',title:'参保地',width:150 },
			{field:'TabHosYJ',title:'医院意见',width:150 },
			{field:'TabJSYJ',title:'家属意见',width:150 },
			{field:'TabAdmSeriNo',title:'住院流水号',width:220},
			{field:'TabMD',title:'	目的',width:150 },
			{field:'TabZZ',title:'症状',width:150 },	
			{field:'TabBZ',title:'备注',width:150 },
			{field:'TabRptType',hidden:true },	
			{field:'rowid',hidden:true}
		]];

	// 初始化DataGrid
	$('#dg').datagrid({
		data:[],
		fit: true,
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
	if(getValueById('INSUType')==''){
		$.messager.alert('提示','医保类型不能为空','info');
		return;	
	}
    var queryParams = {
	    ClassName : 'web.INSUReport',
	    QueryName : 'QueryAll',
	    Rptlb : getValueById('Rptlb'),
	    StartDate : getValueById('StartDate'),
	    EndDate : getValueById('EndDate'),
	    HospId: GV.HospDr,
	    PatName:getValueById('PatName'),
	    PatId:getValueById('PatId'),
	    RptSt:$("input[name='RptSt']:checked").val(),
	    ParamINSUType:getValueById('INSUType')
	    
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
 * 新增
 */
$('#btnAdd').bind('click', function () {
	var INSUType = getValueById('INSUType');
	if(INSUType == ''){
		$.messager.alert('提示','请先选择医保类型','info');
		return;	
	}
	openEditWindow();
});

/*
 * readcard
 */
$('#btnReadCard').bind('click', function () {
	var CardType="1",InsuNo="";
	var ExpString = getValueById('INSUType') + '^' + GV.HospDr;
	var UserId = session['LOGON.USERID'];
	CardType=getValueById('certtype');	
	//alert(CardType)
	//return ;
	var str = InsuReadCard('0',UserId,InsuNo,CardType,ExpString);
	//alert("str="+str)
	var TmpData = str.split("|");
	if (TmpData[0]!="0"){
		$.messager.alert('提示', "读卡失败" + str, 'error');	
		return;
	}else{
		//0|44020000000000612456^440202196908200014^^张力^1^01^1969-08-20^^粤北人民医院^^^11^^0^^^^^^^^440299^^^^01^440202196908200014^||310||非公务员|440299|粤北人民医院|||||@||||||||||@|||||||@.
		//alert("TmpData[1]="+TmpData[1])
	 	var TmpData1 = TmpData[1].split("^")
	 	 
	 	setValueById('PatNo',TmpData1[0]); //个人编号
	 	setValueById('INSUCardNo',TmpData1[1]);  //卡号
	 	setValueById('name',TmpData1[3]); //姓名
	 	setValueById('Sex',TmpData1[4]); //性别
	 	setValueById('States',TmpData1[21]); //参保人所属地
	 	setValueById('rylb',TmpData1[11]);  //人员类别	 
	 	
	 	setValueById('xzlx',TmpData[3]);  //险种类型
	 	 
	 }
    
});
/**
* 数据校验
*/
function checkData() {
	var inValiddatebox = $('.validatebox-invalid');
	if(inValiddatebox.length > 0){ //validdatebox
		$.each(inValiddatebox, function (index, rowData) {
			var labelDesc = $('#Label' + rowData.id).text() || '值: ' + rowData.value;
			$.messager.alert('提示', '[' + labelDesc +']' + '验证不通过' , 'error');
			throw rowData.id;
		});		
	}
}
/*
 * 保存
 */
$('#btnReport').bind('click', function () {
	try{
		
		//checkData();
		var PatNo = getValueById('PatNo');
		var Name=getValueById('name');
		var RptType = getValueById('RptType');
		var AdmSeriNo = '';
		var OutHosName = '';
		var HosLevel = '';
		var DiagCode = getValueById('DiagCode');
		var DiagDesc = $('#DiagCode').combobox('getText');
		var HosYJ = getValueById('HosYJ');
		//var xmbm = getValueById('xmbm');
		//var xmmc = $('#xmbm').combobox('getText');	
		//var sl = getValueById('sl');
		var RptDate =GetInsuDateFormat(getValueById('RptDate'));	
		var SDate = GetInsuDateFormat(getValueById('SDate'));	
		var EDate = GetInsuDateFormat(getValueById('EDate'));	
		var Guser = session['LOGON.USERID'];
		var OutHosName = '';
		var GuserName = session['LOGON.USERNAME'];
		var OutType = '';
		var Demo = '';
		//var money = getValueById('money');
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
		var AdmType = '';
		var NumberID = '';
		var States =  $('#States').combobox('getText'); 
		var HospId = GV.HospDr;
		var insutype=getValueById('xzlx');
		var MXBDiagCode=$('#DiagCodeMXB').combobox('getValue'); 
		var MXBDiagDesc=$('#DiagCodeMXB').combobox('getText'); 
		if (RptType=="01"){
			if(MXBDiagCode=="" || MXBDiagDesc==""){$.messager.alert('错误', "门诊慢特病备案失败,失败原因:请选择门慢特病病种!", 'error');return;}
			
			}
		var YLLB=getValueById('InAdmType')
		
		var HiType=getValueById('INSUType');
		
		//alert("Doctor="+Doctor+"DoctorCode="+DoctorCode)
		//return ;
		
        //              0      1      2       3            4         5          6       7         8      9      10     11      12         13
		var ExpString =HiType+"^"+""+"^"+""+"^"+ PatNo +"^"+ Name +"^"+RptType+"^"+""+"^"+RptDate+"^"+""+"^"+YLLB+"^"+MXBDiagCode+"^"+MXBDiagDesc+"^"+SDate+"^"+EDate
		var ExpString=ExpString+"^^^^^^^^^^^^^^^^^^^"+States+"^^^^^^^"
		var ExpString=ExpString+"^"+""+"^^^"+""+"^"+Doctor+"^"+DoctorCode+"^^^"+insutype+"^"+""+"^"
		
		/*
		var str=str+"^"+OutHosName+"|"+HosLevel+"|"+DiagCode+"|"+DiagDesc+"|"+HosYJ+"|"+xmbm+"|"+xmmc+"|"+sl+"|"+RptDate+"|"+SDate+"|"+EDate+"|"+GuserName+"|";	
		str = str + OutType+"|"+Demo+"|"+money+"|"+xmlb+"|"+RPTNo+"|"+ZYZZ+"|"+MD+"|"+Doctor+"|"+KZR+"|"+JSYJ+"|"+KZRYJ+"|"+LRuser+"|"+LRDate+"|"+RPTUser+"|";
		str = str + HisCode+"|"+HisDesc+"|"+AdmType+"|"+NumberID + "|" + States;
		ExpString = getValueById('INSUType') + '^^' +getValueById('name'); // insutype^ExpStrForNet^Name
		*/
		
		//^^^人员编号^人员姓名^备案类型^^备案日期^^医疗类别（可为空）^门慢特病病种编码^
		//门慢特病病种名称^开始日期^结束日期（可为空）^^^^^^^^^^^^^^^^^^^参保区划^^^^^^^
		//联系电话^^^鉴定机构编码(可为空)^鉴定机构名称（可为空）^诊断医师编码^诊断医师名称^^^险种类型^联系地址^
		
		
		var rtn=InsuReport(0, Guser,ExpString,"");
		if (rtn == 0){
			$.messager.alert('提示', "备案成功!：" + rtn, 'info',function(){
				$HUI.dialog("#LocalListInfoProWin",'close');
				initLoadGrid();	
			});	
		} else{
			$.messager.alert('错误', "备案失败!：" + rtn, 'error');
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
		if (selected.rowid != "") {
			$.messager.confirm('确认', '确认撤销备案记录？', function (r) {
				if (r) {
					var str=selected.TabRptType + "|"  + selected.TabPatNo + "|" + selected.TabAdmSeriNo + "|" + selected.TabDiagCode + "|" + selected.TabDiagDesc + "|" + selected.TabSDate
					//ExpString = selected.rowid + "|";
						
						/*
						var Reason
						
						$HUI.dialog("#Reason",{
						title:"输入撤销备案原因",
						height:400,
						width:500,
						collapsible:true,
						content:"<textarea id='ta' style='height:400;width:500'></textarea>",
						pagination:true,toolbar:[{
								iconCls: 'icon-edit',
								text:'编辑',
								handler: function(){
									Reason=$('#ta').val()	
								}
								
													
							}] 
						})
						*/
						var Reason="需要重新备案"
					if(Reason==""){$.messager.alert('错误', "备案撤销失败!请输入备案撤销原因", 'info');return; }
					//var ExpString = getValueById('INSUType') + '^' + GV.HospDr;
					var HiType=getValueById('INSUType'); // DingSH 20210714
					//var rtn=tkMakeServerCall("web.INSUReport", "DeleteReport", selected.rowid); //DHCINSUBLL.InsuReportDestroy(1,str,Guser,ExpString);
					var rtn=InsuReportDestory(1,session['LOGON.USERID'],selected.rowid,"",Reason+"^"+HiType)	
				    if (rtn!="0"){
					    $.messager.alert('错误', "备案撤销失败!" + rtn, 'info');
					}else {
						$.messager.alert('错误', "备案撤销成功!" + rtn, 'info',function(){
							initLoadGrid();	
						});
				    }
				}
			});
		}
	} else {
		$.messager.alert('提示', "请选择要删除的记录", 'info');
	}
});


/*
 * 查询
 */
$('#btnSearch').bind('click', function () {
	var selected = $('#dg').datagrid('getSelected');    
	if (selected) { 
		if (selected.rowid != "") {                                      //查单条
		 	var RptType = getValueById('RptType');
			$.messager.confirm('确认', '确认查询该条备案记录？', function (r) {
				if (r) {
					var str=selected.TabRptType + "|"  + selected.TabPatNo + "|" + selected.TabAdmSeriNo + "|" + selected.TabDiagCode + "|" + selected.TabDiagDesc + "|" + selected.TabSDate
					 
					var rtn=InsuReportQuery(1,"","",session['LOGON.USERID'],selected.rowid,RptType,"")	
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
		 var RptType = getValueById('RptType');
	     var rtn=InsuReportQuery(1,SDate,EDate,session['LOGON.USERID'],"",RptType,"")	                                                
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
/* 新增/修改弹窗
 */
function openEditWindow(){
	$('#LocalListInfoProWin').show(); 
	$HUI.dialog("#LocalListInfoProWin",{
			title:"申报信息",
			height:527,
			width:570,
			collapsible:false,
			modal:true,
		    iconCls: 'icon-w-edit'
	})
	$("#addInfo").form("clear");
	
	init_AddInfoPanel();	
	
}
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
 * 新增弹窗
 */
function init_AddInfoPanel(){
	setValueById('SDate',getDefStDate(0));
	setValueById('EDate',getDefStDate(1));
	setValueById('RptDate',getDefStDate(0));
	Options = {
		hospDr: GV.HospDr	
	}
	// 审批类别
	INSULoadDicData('RptType','RTPType' + getValueById('INSUType'),Options); 	
	// 人员类别
	INSULoadDicData('rylb','AKC021' + getValueById('INSUType'),Options); 
	// states
	INSULoadDicData('States','YAB003' + getValueById('INSUType'),Options); 
	Options = {
		hospDr: GV.HospDr,
		//DicOPIPFlag:"OP"	
	}
	// 医疗类别
	INSULoadDicData('InAdmType','AKA130' + getValueById('INSUType'),Options); 
	// 数量，金额
	setValueById('money','0');
	setValueById('sl','1');
	
	// HIS项目编码
	$HUI.combobox(('#xmbm'),{
		defaultFilter:'4',
		valueField: 'HisCode',
		textField: 'HisDesc',
		url:$URL,
		mode:'remote',
		onBeforeLoad:function(param){
			if(param.q==''){
				return true;	
			}
			param.ClassName = 'web.INSUTarContrastCom';
			param.QueryName= 'DhcTarQuery';
			param.sKeyWord = param.q;
			param.Class = '1';
			param.Type = getValueById('INSUType');
			param.ConType = 'A';
			param.ExpStr = 'N||' + GV.HospDr;
			param.ResultSetType = 'array';
		},
		onLoadSuccess:function(data){

		}		
	})
	Options = {
		defaultFlag:'N',
		hospDr: GV.HospDr	
	}
	// 慢性病诊断
	INSULoadDicData('DiagCodeMXB','opsp_dise_cod' + getValueById('INSUType'),Options); 
	
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
	})
	
	
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
			{field:'code',title:'编码',width:100} ,
			{field:'name',title:'名称',width:100}
			
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
			 
			setValueById('DoctorCode',rowData.name)
			
			}	
	})
	
	
	
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
	})
	// sex
	$('#Sex').combobox({
		valueField: 'id',
		textField: 'text',
		editable: false,
		data:[{
    			"id" : '男',
    			"text":"男",
    			selected:true
    		},{
    			"id" : '女',
    			"text":"女"	
    		},{
    			"id" : '未知',
    			"text":"未知"	
    		}]		
	})
}

