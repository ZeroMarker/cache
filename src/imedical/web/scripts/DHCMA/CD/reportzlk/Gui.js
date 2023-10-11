$(function () {
	InitReportWin();
});

function InitReportWin(){
	var obj = new Object(); 	  
	obj.ReportID=ReportID;
	obj.CRZD ='';  
	obj.CRYZD='';
	obj.CRSWZD ='';
	obj.CRZDBWID = '';
	obj.CRBLXLXID = '';
	obj.CRJPXBMID = '';
	obj.CRGZ= ''; 
	if (EmrOpen==1){
	    $('.page-footer').css('display','none');
    }    

	$('#cboPatAgeDW').combobox({});  //年龄单位 
	$('#cboCRGZ').combobox({});      //工种      
	obj.cboCRZY = Common_ComboToDic("cboCRZY","CRZY","",LogonHospID);                        //职业
	obj.cboCRBQYGZBR = Common_ComboToDic("cboCRBQYGZBR","CRBQYGZBR","",LogonHospID);                    //病情已告知病人
	obj.cboCRMZ = Common_ComboToDic("cboCRMZ","CRMZ","",LogonHospID);                                   //民族
	obj.cboCRTNMFQT = Common_ComboToDic("cboCRTNMFQT","CRTNMFQT","",LogonHospID);                       //T
	obj.cboCRTNMFQN = Common_ComboToDic("cboCRTNMFQN","CRTNMFQN","",LogonHospID);                       //N
	obj.cboCRTNMFQM = Common_ComboToDic("cboCRTNMFQM","CRTNMFQM","",LogonHospID);                       //M
	obj.cboCRFHCD = Common_ComboToDic("cboCRFHCD","CRFHCD","",LogonHospID);                             //期别
	obj.cboCRZGZDDW = Common_ComboToDic("cboCRZGZDDW","CRZGZDDW","",LogonHospID);                       //最高诊断单位             
	obj.cboCRReportLoc = Common_ComboToLoc2("cboCRReportLoc","E","","",LogonHospID);  //报卡科室
	obj.cboCRSWYY = Common_ComboToDic("cboCRSWYY","CRSWYYzlk","",LogonHospID);                          //死亡原因
    
	obj.cboEducation = Common_ComboToDic("cboEducation","CRDTHEducation","",LogonHospID);               //文化 
	obj.cboMarital = Common_ComboToDic("cboMarital","CRDTHMarriage","",LogonHospID);                    //婚姻情况 
	obj.cboCardType = Common_ComboToDic("cboCardType","CRCardType","",LogonHospID);                    // 证件类型
	
	
	obj.RelationOne = Common_ComboToDic("RelationOne","PatRelation","",LogonHospID);                    // 与患者关系1
	obj.RelationTwo = Common_ComboToDic("RelationTwo","PatRelation","",LogonHospID);                    // 与患者关系2
	obj.RelationThr = Common_ComboToDic("RelationThr","PatRelation","",LogonHospID);                    // 与患者关系3
	obj.cboAction = Common_ComboToDic("cboAction","ZLKAction","",LogonHospID);                    //  行为
	
	
	//职业工种联动
	$('#cboCRZY').combobox({                                                               //工种
	    onSelect:function(rows){
		    $('#cboCRGZ').combobox('clear');
		    obj.CRGZ=rows["DicCode"];
		    obj.cboCRGZ = Common_ComboToDic("cboCRGZ","CDGZ"+obj.CRGZ,"",LogonHospID);
	    }
    });
    
    obj.cboProvince1 = Common_ComboToArea2("cboProvince1","1",1);                             // 省
	obj.RegCity = $HUI.combobox('#cboProvince1', {
		onChange:function(newValue,oldValue){
			$('#cboCity1').combobox('clear');
			$('#cboCounty1').combobox('clear');
			$('#cboVillage1').combobox('clear');
			$('#txtCUN1').val('');
			obj.cboCity1 = Common_ComboToArea2("cboCity1","cboProvince1",2);				// 市
		}
		
	});
	obj.RegCounty = $HUI.combobox('#cboCity1', {
		onChange:function(newValue,oldValue){
			$('#cboCounty1').combobox('clear');
			$('#cboVillage1').combobox('clear');
			$('#txtCUN1').val('');
			obj.cboCounty1 = Common_ComboToArea2("cboCounty1","cboCity1",3);             // 县
		}
	});
	obj.RegVillage = $HUI.combobox('#cboCounty1', {
		onChange:function(newValue,oldValue){
			$('#cboVillage1').combobox('clear');
			$('#txtCUN1').val('');
			obj.cboVillage1 = Common_ComboToArea2("cboVillage1","cboCounty1",4);         // 乡
		}
	});
	$HUI.combobox('#cboVillage1', {                                                    //村
		onSelect:function(record){
			if (record) {
			    $('#txtCUN1').val('');
			    $('#txtAdress1').val($('#cboProvince1').combobox('getText')+$('#cboCity1').combobox('getText')+$('#cboCounty1').combobox('getText')+$('#cboVillage1').combobox('getText'));
			}
		}
	});
	//动态添加村（input）的内容
	$('#txtCUN1').bind('change', function (e) {  //鼠标移动之后事件 
		$('#txtAdress1').val($('#cboProvince1').combobox('getText')+$('#cboCity1').combobox('getText')+$('#cboCounty1').combobox('getText')+$('#cboVillage1').combobox('getText')+$('#txtCUN1').val());
	});
	
	obj.cboProvince2 = Common_ComboToArea2("cboProvince2","1",1);                        // 省
	obj.RegCity2 = $HUI.combobox('#cboProvince2', {
		onChange:function(newValue,oldValue){
			$('#cboCity2').combobox('clear');
			$('#cboCounty2').combobox('clear');
			$('#cboVillage2').combobox('clear');
			$('#txtCUN2').val('');
			obj.cboCity2 = Common_ComboToArea2("cboCity2","cboProvince2",2);				// 市
		}
		
	});
	obj.RegCounty2 = $HUI.combobox('#cboCity2', {
		onChange:function(newValue,oldValue){
			$('#cboCounty2').combobox('clear');
			$('#cboVillage2').combobox('clear');
			$('#txtCUN2').val('');
			obj.cboCounty2 = Common_ComboToArea2("cboCounty2","cboCity2",3);             // 县
		}
	});
	obj.RegVillage2 = $HUI.combobox('#cboCounty2', {
		onChange:function(newValue,oldValue){
			$('#cboVillage2').combobox('clear');
			$('#txtCUN2').val('');
			obj.cboVillage2 = Common_ComboToArea2("cboVillage2","cboCounty2",4);         // 乡
		}
	});
	$HUI.combobox('#cboVillage2', {
		onSelect:function(record){
			if (record) {
			    $('#txtCUN2').val('');
			    	$('#txtAdress2').val($('#cboProvince2').combobox('getText')+$('#cboCity2').combobox('getText')+$('#cboCounty2').combobox('getText')+$('#cboVillage2').combobox('getText'));
			}
		}
	});
	//动态添加村（input）的内容
	$('#txtCUN2').bind('change', function (e) {  //鼠标移动之后事件 
		$('#txtAdress2').val($('#cboProvince2').combobox('getText')+$('#cboCity2').combobox('getText')+$('#cboCounty2').combobox('getText')+$('#cboVillage2').combobox('getText')+$('#txtCUN2').val());
	});
	
	//诊断部位
	obj.cboCRZDBW = $('#cboCRZDBW').lookup({
		panelWidth:450,
		url:$URL,
		editable: true,
		mode:'remote',      //当设置为 'remote' 模式时，用户输入的值将会被作为名为 'q' 的 http 请求参数发送到服务器，以获取新的数据。
		valueField: 'ID',
		textField: 'CRDesc',
		pagination:true,
		loadMsg:'正在查询',
		isCombo:true,             //是否输入字符即触发事件，进行搜索		
		queryParams:{ClassName: 'DHCMed.CDService.DiagnosPosSrv',QueryName: 'QryDiagPos',aIsActive:1},
		columns:[[  
			{field:'CRCode',title:'代码',width:80},   
			{field:'CRDesc',title:'诊断部位',width:350}  
		]],
		onBeforeLoad:function(param){
	        var desc=param['q'];
	        //if (desc=="") return false;        
			param = $.extend(param,{aAlias:desc}); //将参数q转换为类中的参数
	    },
		onSelect:function(index,rowData){
			obj.CRZDBWID = rowData['ID'];
			var CRCode = rowData['CRCode'];
			//根据诊断部位编码查找诊断
			$m({
				ClassName:"DHCMed.CD.CRICDDx",
				MethodName:"GetICDByCode",
				aCode:CRCode
			},function(td){
				if (!td) return;
				obj.CRZD = td.split(CHR_1)[0];
				var ZDICD = td.split(CHR_1)[1];
				var ZDDesc = td.split(CHR_1)[2];
				$('#cboCRZD').lookup('setText',ZDDesc);
				$('#txtCRZDICD').val(ZDICD);
					
			});				
		}
	});  
	
	//诊断
	obj.cboCRZD = $('#cboCRZD').lookup({
		panelWidth:650,
		url:$URL,
		editable: true,
		mode:'remote',      //当设置为 'remote' 模式时，用户输入的值将会被作为名为 'q' 的 http 请求参数发送到服务器，以获取新的数据。
		valueField: 'ID',
		textField: 'FullName',
		pagination:true,
		loadMsg:'正在查询',	
		isCombo:true,             //是否输入字符即触发事件，进行搜索		
		queryParams:{ClassName: 'DHCMed.CDService.ICDDxSrv',QueryName: 'QryICDDx',aIsActive:1},
		columns:[[  
			{field:'CRCode',title:'ICD10',width:80},   
			{field:'FullName',title:'诊断描述',width:550}  
		]],
		onBeforeLoad:function(param){
	        var desc=param['q'];
	        //if (desc=="") return false;        
			param = $.extend(param,{aAlias:desc}); //将参数q转换为类中的参数
	    },
		onSelect:function(index,rowData){
			var ICD10=rowData['CRCode'];
			$('#txtCRZDICD').val(ICD10);            //给相关的ICD10赋值	
			obj.CRZD = rowData['ID'];			
		}
	});  
	$('#cboCRZD').bind('change', function (e) {  
		if($('#cboCRZD').lookup("getText")==""){
			$('#txtCRZDICD').val('');            //给相关的ICD10赋值
		}
	});
	
	//原诊断
	obj.cboCRYZD = $('#cboCRYZD').lookup({
		panelWidth:650,
		url:$URL,
		editable: true,
		mode:'remote',      //当设置为 'remote' 模式时，用户输入的值将会被作为名为 'q' 的 http 请求参数发送到服务器，以获取新的数据。
		valueField: 'ID',
		textField: 'FullName',
		pagination:true,
		loadMsg:'正在查询',	
		isCombo:true,             //是否输入字符即触发事件，进行搜索		
		queryParams:{ClassName: 'DHCMed.CDService.ICDDxSrv',QueryName: 'QryICDDx',aIsActive:1},
		columns:[[  
			{field:'CRCode',title:'ICD10',width:80},   
			{field:'FullName',title:'诊断描述',width:550}  
		]],
		onBeforeLoad:function(param){
	        var desc=param['q'];
	        //if (desc=="") return false;        
			param = $.extend(param,{aAlias:desc}); //将参数q转换为类中的参数
	    },
		onSelect:function(index,rowData){
			var ICD10=rowData['CRCode'];
			$('#txtCRYZDICD').val(ICD10);            //给相关的ICD10赋值	
			obj.CRYZD = rowData['ID'];			
		}
	});  
	$('#cboCRYZD').bind('change', function (e) {   //原诊断
		if($('#cboCRYZD').lookup("getText")==""){
			$('#txtCRYZDICD').val('');             //给相关的ICD10赋值
		}
	});
	
	//解剖学编码
	obj.cboJPXBM = $('#cboJPXBM').lookup({
		panelWidth:450,
		url:$URL,
		editable: true,
		mode:'remote',      //当设置为 'remote' 模式时，用户输入的值将会被作为名为 'q' 的 http 请求参数发送到服务器，以获取新的数据。
		valueField: 'ID',
		textField: 'CRDesc',
		pagination:true,
		loadMsg:'正在查询',	
		isCombo:true,             //是否输入字符即触发事件，进行搜索
		queryParams:{ClassName: 'DHCMed.CDService.AnatomySrv',QueryName: 'QryAnatomy',aIsActive:1},
		columns:[[  
			{field:'CRCode',title:'代码',width:80},   
			{field:'CRDesc',title:'解剖学描述',width:350}  
		]],
		onBeforeLoad:function(param){
	        var desc=param['q'];  
			param = $.extend(param,{aAlias:desc}); //将参数q转换为类中的参数
	    },
		onSelect:function(index,rowData){
			obj.CRJPXBMID = rowData['ID'];			
		}
	});  

	//病理类型
	obj.cboCRBLXLX = $('#cboCRBLXLX').lookup({
		panelWidth:450,
		url:$URL,
		editable: true,
		mode:'remote',      //当设置为 'remote' 模式时，用户输入的值将会被作为名为 'q' 的 http 请求参数发送到服务器，以获取新的数据。
		valueField: 'ID',
		textField: 'CRDesc',
		pagination:true,
		loadMsg:'正在查询',	
		isCombo:true,             //是否输入字符即触发事件，进行搜索
		queryParams:{ClassName: 'DHCMed.CDService.PathologySrv',QueryName: 'QryPathology',aIsActive:1},
		columns:[[  
			{field:'CRCode',title:'代码',width:80},   
			{field:'CRDesc',title:'病理学描述',width:350}  
		]],
		onBeforeLoad:function(param){
	        var desc=param['q'];
	        //if (desc=="") return false;        
			param = $.extend(param,{aAlias:desc}); //将参数q转换为类中的参数
	    },
		onSelect:function(index,rowData){
			obj.CRBLXLXID = rowData['ID'];			
		}
	});  

	obj.cboCRSWZD = Common_LookupToICD("cboCRSWZD");             //死亡诊断
	$("#cboCRSWZD").lookup({onSelect:function(index,rowData){ //死亡诊断
		$('#txtCRSYICD').val(rowData['ICD10']);
		obj.CRSWZD = rowData['ICDRowID'];
	}});
	$('#cboCRSWZD').bind('change', function (e) {  //诊断
		if($('#cboCRSWZD').lookup("getText")==""){
			$('#txtCRSYICD').val('');            //给相关的ICD10赋值
		}
	});
	obj.LoadListInfo = function() {	  //加载单选、多选列表	
		obj.cbgCRZDYJ = Common_CheckboxToDic("cbgCRZDYJ","CRZDYJ",4);                       //诊断依据
	}


	// 肿瘤报卡历史数据
	obj.gridHistoryList = $HUI.datagrid("#gridHistoryList",{
		fit: true,
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
			{field:'ReportID',title:'报告ID',width:'80'},
			{field:'KPBH',title:'卡片编号',width:'120'}, 
			{field:'PatName',title:'姓名',width:'120'},
			{field:'CRZD',title:'诊断',width:'180'},
			{field:'RepStatusDesc',title:'报告状态',width:'80'},
			{field:'ReportUser',title:'上报人',width:'120'},
			{field:'ReportLoc',title:'报告科室',width:'120'},
			
		]],
		onDblClickRow:function(rowIndex,rowData){
			if(rowIndex>-1){
				obj.gridHistoryList_onDbselect(rowIndex, rowData);
			}
		},onLoadSuccess:function(data){
			//加载成功
			dispalyEasyUILoad(); //隐藏效果
		}
	});

	InitReportWinEvent(obj);       
	obj.LoadEvent();       
	return obj;        
}
