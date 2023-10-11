//页面Gui
var obj = new Object();
function InitPatFindWin(){
	var IsCheckFlag=false;
	obj.EpisodeID="";
	obj.TestSetID="";
	obj.VisitNumID="";
	obj.SpecimenID="";
	obj.BacteriaID="";
	obj.BacteriaID2="";
	obj.LabRepID="";
	obj.OutLabRepID="";
	
	obj.cboTestSet = $HUI.lookup("#cboTestSet", {
		panelWidth:450,
		url:$URL,
		editable: true,
		mode:'remote',      //当设置为 'remote' 模式时，用户输入的值将会被作为名为 'q' 的 http 请求参数发送到服务器，以获取新的数据。
		isValid:true,
		pagination:true,
		loadMsg:'正在查询',	
		isCombo:true,             //是否输入字符即触发事件，进行搜索
		minQueryLen:1,             //isCombo为true时，可以搜索要求的字符最小长度
		valueField: 'ID',
		textField: 'TestSet2',
		queryParams:{ClassName: 'DHCHAI.DPS.LabTestSetSrv',QueryName: 'QryLabTestSetMap',aActive:1},
		columns:[[    
			{field:'TestSet2',title:'检验医嘱名称',width:380}  
		]],
		onBeforeLoad:function(param){
			var desc=param['q'];
			//if (desc=="") return false;  
			param = $.extend(param,{aAlias:desc}); //将参数q转换为类中的参数
		},
		onSelect:function(index,rowData){  
			obj.TestSetID = rowData['ID'];			
		}
	});
	obj.cboSpecimen = $HUI.lookup("#cboSpecimen", {
		panelWidth:450,
		url:$URL,
		editable: true,
		mode:'remote',      //当设置为 'remote' 模式时，用户输入的值将会被作为名为 'q' 的 http 请求参数发送到服务器，以获取新的数据。
		isValid:true,
		pagination:true,
		loadMsg:'正在查询',	
		isCombo:true,             //是否输入字符即触发事件，进行搜索
		minQueryLen:1,             //isCombo为true时，可以搜索要求的字符最小长度
		valueField: 'ID',
		textField: 'SpecDesc',
		queryParams:{ClassName: 'DHCHAI.DPS.LabSpecSrv',QueryName: 'QryLabSpecimen',aActive:1},
		columns:[[  
			{field:'SpecCode',title:'标本代码',width:80},   
			{field:'SpecDesc',title:'标本名称',width:200},
			{field:'IsSteDesc',title:'是否无菌部位',width:120}				
		]],
		onBeforeLoad:function(param){
			var desc=param['q'];
			//if (desc=="") return false;  
			param = $.extend(param,{aAlias:desc}); //将参数q转换为类中的参数
		},
		onSelect:function(index,rowData){  
			obj.SpecimenID = rowData['ID'];			
		}
	});
	obj.cboBacteria = $HUI.lookup("#cboBacteria", {
		panelWidth:450,
		url:$URL,
		editable: true,
		mode:'remote',      //当设置为 'remote' 模式时，用户输入的值将会被作为名为 'q' 的 http 请求参数发送到服务器，以获取新的数据。
		isValid:true,
		pagination:true,
		loadMsg:'正在查询',	
		isCombo:true,             //是否输入字符即触发事件，进行搜索
		minQueryLen:1,             //isCombo为true时，可以搜索要求的字符最小长度
		valueField: 'ID',
		textField: 'BacDesc',
		queryParams:{ClassName: 'DHCHAI.DPS.LabBactSrv',QueryName: 'QryLabBacteria'},
		columns:[[  
			{field:'BacCode',title:'病原体代码',width:90},   
			{field:'BacDesc',title:'病原体名称',width:180},
			{field:'BacName',title:'英文名称',width:160}				
		]],
		onBeforeLoad:function(param){
			var desc=param['q'];
			//if (desc=="") return false;  				
			param = $.extend(param,{aAlias:desc}); //将参数q转换为类中的参数
		},
		onSelect:function(index,rowData){  
			obj.BacteriaID = rowData['ID'];			
		}
	});
	$HUI.combobox("#cboMRBType",{
		url:$URL+'?ClassName=DHCHAI.IRS.CRuleMRBSrv&QueryName=QryCRuleMRB&ResultSetType=Array',
		allowNull: true,       //再次点击取消选中
		valueField:'ID',
		textField:'BTDesc'
	});
	obj.cboBacteria2 = $HUI.lookup("#cboBacteria2", {
		panelWidth:450,
		url:$URL,
		editable: true,
		mode:'remote',      //当设置为 'remote' 模式时，用户输入的值将会被作为名为 'q' 的 http 请求参数发送到服务器，以获取新的数据。
		isValid:true,
		pagination:true,
		loadMsg:'正在查询',	
		isCombo:true,             //是否输入字符即触发事件，进行搜索
		minQueryLen:1,             //isCombo为true时，可以搜索要求的字符最小长度
		valueField: 'ID',
		textField: 'BacDesc',
		queryParams:{ClassName: 'DHCHAI.DPS.LabBactSrv',QueryName: 'QryLabBacteria'},
		columns:[[  
			{field:'BacCode',title:'病原体代码',width:90},   
			{field:'BacDesc',title:'病原体名称',width:180},
			{field:'BacName',title:'英文名称',width:160}				
		]],
		onBeforeLoad:function(param){
			var desc=param['q'];
			//if (desc=="") return false;  				
			param = $.extend(param,{aAlias:desc}); //将参数q转换为类中的参数
		},
		onSelect:function(index,rowData){  
			obj.BacteriaID2 = rowData['ID'];			
		}
	});
	$HUI.combobox("#cboMRBType2",{
		url:$URL+'?ClassName=DHCHAI.IRS.CRuleMRBSrv&QueryName=QryCRuleMRB&ResultSetType=Array',
		allowNull: true,       //再次点击取消选中
		valueField:'ID',
		textField:'BTDesc'
	});
	$HUI.combobox("#cboMRBOutLabType",{
		url:$URL+'?ClassName=DHCHAI.BTS.DictionarySrv&QueryName=QryDic&ResultSetType=Array&aTypeCode=MRBOutLabType&aActive=1',
		allowNull: true,       //再次点击取消选中
		valueField:'ID',
		textField:'DicDesc',
		onSelect:function(rec){
			obj.OutLabRepID="";
			var DateNow=Common_GetDate(new Date());
			$('#LabRepDate').datebox('setValue',DateNow);
			if (rec.DicDesc=="本院外送"){
				obj.OpenINFLabSync();
				$('#cboTestSet').lookup('disable');
				$('#cboSpecimen').lookup('disable');
				$('#SubmissDate').datebox('disable');
				$('#cboTestSet').lookup('setText','');
				$('#cboSpecimen').lookup('setText','');
				$('#SubmissDate').datebox('setValue','');
				$('#cboBacteria').lookup('setText','');
				$('#cboMRBType').combobox('setValue','');
				$('#cboBacteria2').lookup('setText','');
				$('#cboMRBType2').combobox('setValue','');
			}else{
				$('#cboTestSet').lookup('enable');
				$('#cboSpecimen').lookup('enable');
				$('#SubmissDate').datebox('enable');
				$('#cboTestSet').lookup('setText','');
				$('#cboSpecimen').lookup('setText','');
				$('#SubmissDate').datebox('setValue','');
				$('#cboBacteria').lookup('setText','');
				$('#cboMRBType').combobox('setValue','');
				$('#cboBacteria2').lookup('setText','');
				$('#cboMRBType2').combobox('setValue','');
			}	
		}
	});
	obj.OutLabRegList=$('#OutLabRegList').datagrid({
	    fit:true,
	    headerCls:'panel-header-gray',
	    pagination: true, //如果为true, 则在DataGrid控件底部显示分页工具栏
	    rownumbers:true,
	    singleSelect:true,
	    selectOnCheck:true,
	    checkOnSelect:true,
		fitColumns:false,
	    url:$URL,
	    bodyCls:'no-border',
	    queryParams:{
	        ClassName:'DHCHAI.IRS.OutLabReportSrv',
	        QueryName:'QryOutLabRep',
	        aEpisodeID:obj.EpisodeID
	    },
	    columns:[[
	    	{ field:"PapmiNo",title:"登记号",width:110},
			{ field:"PatName",title:"姓名",width:100},
			{ field:"MRBOutLabType",title:"检验报告类型",width:110},
			{ field:"SubmissDate",title:"送检日期",width:100},
			{ field:"LabAuthDate",title:"报告日期",width:100},
			{ field:"BTTestSet",title:"送检医嘱",width:140},
			{ field:"SubmissLoc",title:"送检科室",width:120},
			{ field:"Specimen",title:"标本",width:90},
			{ field:"Bacteria",title:"病原体1",width:160},
			{ field:"RuleMRB",title:"多耐分类1",width:260},
			{ field:"Bacteria2",title:"病原体2",width:160},
			{ field:"RuleMRB2",title:"多耐分类2",width:260}
	    ]],
	    onSelect:function(rowIndex, rowData){
	        obj.btnClear_click();
	        $('#cboMRBOutLabType').combobox('setValue',rowData.MRBOutLabTypeID);
	        $('#cboMRBOutLabType').combobox('setText',rowData.MRBOutLabType);
	        $('#cboTestSet').lookup('setText',rowData.BTTestSet);
			$('#cboSpecimen').lookup('setText',rowData.Specimen);
			$('#SubmissDate').datebox('setValue',rowData.SubmissDate);
			$('#LabRepDate').datebox('setValue',rowData.LabAuthDate);
			$('#cboBacteria').lookup('setText',rowData.Bacteria);
			$('#cboBacteria2').lookup('setText',rowData.Bacteria2);
			$('#cboMRBType').combobox('setValue',rowData.RuleMRBID);
			$('#cboMRBType').combobox('setText',rowData.RuleMRB);
			$('#cboMRBType2').combobox('setValue',rowData.RuleMRBID2);
			$('#cboMRBType2').combobox('setText',rowData.RuleMRB2);
			if (rowData.MRBOutLabType=="本院外送"){
				$('#cboTestSet').lookup('disable');
				$('#cboSpecimen').lookup('disable');
				$('#SubmissDate').datebox('disable');
				obj.OutLabRepID="";
			}else{
				$('#cboTestSet').lookup('enable');
				$('#cboSpecimen').lookup('enable');
				$('#SubmissDate').datebox('enable');
				obj.OutLabRepID=rowData.ID;
			}
			obj.BacteriaID = rowData.BacteriaID;
			obj.BacteriaID2= rowData.BacteriaID2;
			obj.TestSetID  = rowData.BTTestSetID;
			obj.SpecimenID = rowData.SpecimenID;
			obj.VisitNumID = rowData.VisitNumberDr;
			obj.EpisodeID  = rowData.EpisodeID;
			obj.AdmInfo = $cm({
				ClassName:"DHCHAI.DPS.PAAdmSrv",
				QueryName:"QryAdmInfo",		
				aEpisodeID: obj.EpisodeID
			},false);
			if (obj.AdmInfo.total>0) {
				var AdmInfo = obj.AdmInfo.rows[0];
				$('#PatName').text(AdmInfo.PatName);
				$('#Age').text(AdmInfo.Age);	
				$('#txtPapmiNo').text(AdmInfo.PapmiNo);
				$('#txtMrNo').text(AdmInfo.MrNo);
				$('#txtAdmDate').text(AdmInfo.AdmDate);
				$('#txtDisDate').text(AdmInfo.DischDate);
			}
	        
	    },
	    onUnselect:function(rowIndex, rowData){
	        obj.btnClear_click();
	        $('#cboTestSet').lookup('enable');
			$('#cboSpecimen').lookup('enable');
			$('#SubmissDate').datebox('enable');
			obj.OutLabRepID="";
	    },
		onLoadSuccess:function(data){
			dispalyEasyUILoad(); //隐藏效果
		}
	});
	var DateNow=Common_GetDate(new Date());
	$('#LabRepDate').datebox('setValue',DateNow);
	 
	$('#cboTestSet').lookup('setText','');
	//$('#cboTestSet').lookup('disable');
	$('#cboSpecimen').lookup('setText','');
	//$('#cboSpecimen').lookup('disable');
	$('#SubmissDate').datebox('setValue','');
	//$('#SubmissDate').datebox('disable');
	$('#cboBacteria').lookup('setText','');
	$('#cboMRBType').combobox('setValue','');
	$('#cboBacteria2').lookup('setText','');
	$('#cboMRBType2').combobox('setValue','');
			
	InitPatFindWinEvent(obj);
	obj.LoadEvent(arguments);
	return obj;
}
$(function () {
	InitPatFindWin();
});
