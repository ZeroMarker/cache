//页面Event
function InitPatFindWinEvent(obj){
	obj.LoadEvent = function(args){
		$("#aBtnSave").on('click',function(){
			obj.BtnSave_click();
		});
		$("#aBtnDelete").on('click',function(){
			obj.BtnDelete_click();
		});
		obj.ELDisable();
	}
	//初始化就诊信息
	obj.InitPatInfo = function(PatValue)
	{	
		obj.AdmInfo = $cm({
			ClassName:"DHCHAI.DPS.PAAdmSrv",
			QueryName:"QryAdmInfoByName",		
			aIntputs: PatValue
		},false);
		if (obj.AdmInfo.total==1) {
			obj.ELEnable();
			var AdmInfo = obj.AdmInfo.rows[0];
			obj.EpisodeID=AdmInfo.EpisodeID;
			
			$('#PatName').text(AdmInfo.PatName);
			$('#Age').text(AdmInfo.Age);	
			$('#txtPapmiNo').text(AdmInfo.PapmiNo);
			$('#txtMrNo').text(AdmInfo.MrNo);
			$('#txtAdmDate').text(AdmInfo.AdmDate);
			$('#txtDisDate').text(AdmInfo.DischDate);
			obj.reloadOutLabRegList();
		}else if (obj.AdmInfo.total>1){
			obj.OpenPatList();
		}else{
			obj.EpisodeID = "";
			$('#PatName').text("");
			$('#Age').text("");	
			$('#txtPapmiNo').text("");
			$('#txtMrNo').text("");
			$('#txtAdmDate').text("");
			$('#txtDisDate').text("");
			obj.ELDisable();
			obj.reloadOutLabRegList();
		}
	};
	//登记号补零 length位数
	var length=10;
	obj.PapmiNo=""
	$("#txtPatName").keydown(function(event){
		 if (event.keyCode ==13) {
			var PatValue = $("#txtPatName").val();
			obj.InitPatInfo(PatValue);
		}
	});	
	obj.ELDisable = function(){
		obj.TestSetID  = "";
		obj.SpecimenID = "";
		obj.VisitNumID = "";
		obj.LabRepID   = "";
		obj.BacteriaID = "";
		obj.BacteriaID2= "";
		obj.EpisodeID  = "";
		$('#cboMRBOutLabType').combobox('disable');
		$('#cboTestSet').lookup('disable');
		$('#cboSpecimen').lookup('disable');
		$('#SubmissDate').datebox('disable');
		$('#cboBacteria').lookup('disable');
		$('#cboBacteria2').lookup('disable');
		$('#cboSpecimen').lookup('disable');
		$('#cboMRBType').combobox('disable');
		$('#cboMRBType2').combobox('disable');
		$('#cboTestSet').lookup('setText','');
		$('#cboSpecimen').lookup('setText','');
		$('#SubmissDate').datebox('setValue','');
		$('#cboBacteria').lookup('setText','');
		$('#cboMRBType').combobox('setValue','');
		$('#cboBacteria2').lookup('setText','');
		$('#cboMRBType2').combobox('setValue','');
		$('#cboMRBOutLabType').combobox('setValue','');
	}
	obj.ELEnable = function(){
		obj.TestSetID  = "";
		obj.SpecimenID = "";
		obj.VisitNumID = "";
		obj.LabRepID   = "";
		obj.BacteriaID = "";
		obj.BacteriaID2= "";
		$('#cboMRBOutLabType').combobox('enable');
		$('#cboTestSet').lookup('enable');
		$('#cboSpecimen').lookup('enable');
		$('#SubmissDate').datebox('enable');
		$('#cboBacteria').lookup('enable');
		$('#cboBacteria2').lookup('enable');
		$('#cboSpecimen').lookup('enable');
		$('#cboMRBType').combobox('enable');
		$('#cboMRBType2').combobox('enable');
		$('#cboTestSet').lookup('setText','');
		$('#cboSpecimen').lookup('setText','');
		$('#SubmissDate').datebox('setValue','');
		$('#cboBacteria').lookup('setText','');
		$('#cboMRBType').combobox('setValue','');
		$('#cboBacteria2').lookup('setText','');
		$('#cboMRBType2').combobox('setValue','');
		$('#cboMRBOutLabType').combobox('setValue','');
	}
	//清楚按钮
	obj.btnClear_click = function(){
		obj.TestSetID  = "";
		obj.SpecimenID = "";
		obj.VisitNumID = "";
		obj.LabRepID   = "";
		obj.BacteriaID = "";
		obj.BacteriaID2= "";
		$('#cboTestSet').lookup('setText','');
		$('#cboSpecimen').lookup('setText','');
		$('#SubmissDate').datebox('setValue','');
		$('#cboBacteria').lookup('setText','');
		$('#cboMRBType').combobox('setValue','');
		$('#cboBacteria2').lookup('setText','');
		$('#cboMRBType2').combobox('setValue','');
		$('#cboMRBOutLabType').combobox('setValue','');
		$('#cboMRBOutLabType').combobox('enable');
		$('#cboTestSet').lookup('enable');
		$('#cboSpecimen').lookup('enable');
		$('#SubmissDate').datebox('enable');
		$('#cboBacteria').lookup('enable');
		$('#cboBacteria2').lookup('enable');
		$('#cboSpecimen').lookup('enable');
		$('#cboMRBType').combobox('enable');
		$('#cboMRBType2').combobox('enable');
	}
	//摘要
	obj.btnAbstractMsg_Click = function(EpisodeID)
	{	
		var strUrl = '../csp/dhchai.ir.view.main.csp?PaadmID='+EpisodeID+'&PageType=WinOpen';
		websys_createWindow(strUrl,"","width=95%,height=95%");
	};
	
	//电子病历
	obj.btnEmrRecord_Click = function(EpisodeID,PatientID)
	{		
		var strUrl = cspUrl+'&PatientID=' + PatientID+'&EpisodeID='+EpisodeID + '&DefaultOrderPriorType=ALL&2=2';		
		websys_createWindow(strUrl,"","width=95%,height=95%");
	};
	//获取当前页面的缩放值
	function detectZoom() {
		var ratio = 1;
		if(BrowserVer=="isChrome") {   //医为浏览器为 Chrome 49
			var userAgent = navigator.userAgent;
            var ChromePos = userAgent.indexOf("Chrome");  //Chrome定位
            var ChromeStr = userAgent.substr(ChromePos);  //Chrome串
            var ChromeArr = ChromeStr.split(" ");
            var ChromeVer = parseInt(ChromeArr[0].split("/")[1]);      //Chrome版本
			if (ChromeVer<=58) {    
				ratio = window.devicePixelRatio;
			}
		}
		return ratio;
	}
    
	//保存事件
	obj.BtnSave_click = function(){
		var MRBOutLabTypeID   = $('#cboMRBOutLabType').combobox('getValue');
		var MRBOutLabTypeDesc = $('#cboMRBOutLabType').combobox('getText');
		var TestSetID   = obj.TestSetID;
		var TSDesc      = $('#cboTestSet').lookup('getText');
		var SpecimenID  = obj.SpecimenID;
		var Specimen    = $('#cboSpecimen').lookup('getText');
		var SubmissDate = $('#SubmissDate').datebox('getValue');
		var BacteriaID  = obj.BacteriaID;
		var Bacteria1   = $('#cboBacteria').lookup('getText');
		var MRBTypeID1  = $('#cboMRBType').combobox('getValue');
		var BacteriaID2 = obj.BacteriaID2;
		var Bacteria2   = $('#cboBacteria2').lookup('getText');
		var MRBTypeID2  = $('#cboMRBType2').combobox('getValue');
		var LabRepDate  = $('#LabRepDate').datebox('getValue');
		var errorStr = '';
		if (!MRBOutLabTypeDesc) {
			errorStr = errorStr + "请填写报告方式!<br>"; 
		}
		if (!TestSetID) {
			errorStr = errorStr + "请填写检验医嘱!<br>"; 
		}
		if (!SpecimenID) {
			errorStr = errorStr + "请填写标本!<br>"; 
		}
		if (!SubmissDate) {
			errorStr = errorStr + "请填写送检日期!<br>"; 
		}
		if (!LabRepDate) {
			errorStr = errorStr + "请填写报告日期!<br>"; 
		}
		if (!BacteriaID) {
			errorStr = errorStr + "请填写病原体!<br>"; 
		}
		if(obj.LabRepID!=""){
			errorStr = errorStr + "选中的送检记录存在结果，不能录入结果!<br>"; 
		}
		if (errorStr!="") { 
			$.messager.alert("提示", errorStr, 'info');
			return; 
		}
		
		if (MRBOutLabTypeDesc=="外院携带"){
			var Input = obj.OutLabRepID;
			Input = Input + CHR_1 + obj.EpisodeID;
			Input = Input + CHR_1 + TestSetID;
			Input = Input + CHR_1 + SpecimenID;
			Input = Input + CHR_1 + BacteriaID;
			Input = Input + CHR_1 + MRBTypeID1;
			Input = Input + CHR_1 + BacteriaID2;
			Input = Input + CHR_1 + MRBTypeID2;
			Input = Input + CHR_1 + SubmissDate;
			Input = Input + CHR_1 + "";
			Input = Input + CHR_1 + LabRepDate;
			Input = Input + CHR_1 + 1;
			
			//保存
			var flg = $m({
				ClassName:"DHCHAI.IR.OutLabReport",
				MethodName:"Update",
				aInputStr:Input,
				aSeparete:CHR_1
			},false);
			if (parseInt(flg) < 1) {
				$.messager.alert("错误提示","保存失败!Error=" + flg, 'info');
				return;
			} else {
				$.messager.popover({msg: '保存成功！',type:'success',timeout: 1000});
				$('#cboMRBOutLabType').combobox('setValue','');
				$('#cboTestSet').lookup('setText','');
				$('#cboSpecimen').lookup('setText','');
				$('#SubmissDate').datebox('setValue','');
				$('#cboBacteria').lookup('setText','');
				$('#cboMRBType').combobox('setValue','');
				$('#cboBacteria2').lookup('setText','');
				$('#cboMRBType2').combobox('setValue','');
				obj.TestSetID="";
				obj.VisitNumID="";
				obj.SpecimenID="";
				obj.BacteriaID="";
				obj.BacteriaID2="";
				obj.LabRepID="";
				obj.reloadOutLabRegList();
			}
		}else{
			var Input = "";
			Input = Input + CHR_1 + obj.EpisodeID;
			Input = Input + CHR_1 + obj.VisitNumID;
			Input = Input + CHR_1 + BacteriaID;
			Input = Input + CHR_1 + MRBTypeID1;
			Input = Input + CHR_1 + BacteriaID2;
			Input = Input + CHR_1 + MRBTypeID2;
			Input = Input + CHR_1 + LabRepDate;
			Input = Input + CHR_1 + obj.TestSetID;
			//保存
			var flg = $m({
				ClassName:"DHCHAI.DPS.LabVisitRepSrv",
				MethodName:"SaveOutLabReport",
				aInputStr:Input,
				aSeparete:CHR_1
			},false);
			if (parseInt(flg) < 1){
				$.messager.alert("错误提示","保存失败!Error=" + flg, 'info');
				return;
			} else {
				$.messager.popover({msg: '保存成功！',type:'success',timeout: 1000});
				$('#cboMRBOutLabType').combobox('setValue','');
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
				obj.TestSetID="";
				obj.VisitNumID="";
				obj.SpecimenID="";
				obj.BacteriaID="";
				obj.BacteriaID2="";
				obj.LabRepID="";
				obj.reloadOutLabRegList();
			}
		}
	}
	//删除事件
	obj.BtnDelete_click = function(){
		var rowData = $('#OutLabRegList').datagrid('getSelected');
		if (rowData==null){
			$.messager.alert("提示", "请选中数据,再点击删除!", 'info');
			return;
		}
		var ID = rowData["ID"];
		var MRBOutLabType = rowData["MRBOutLabType"];
		if (MRBOutLabType=="外院携带"){
			$.messager.confirm("删除", "确认是否删除?", function (r) {
				if (r) {				
					var flg = $m({
						ClassName:"DHCHAI.IR.OutLabReport",
						MethodName:"DeleteById",
						aId:ID
					},false);
					
					if (flg == '0') {
						$.messager.popover({msg: '删除成功！',type:'success',timeout: 1000});
						obj.btnClear_click();
						obj.reloadOutLabRegList();
					} else {
						$.messager.alert("错误提示","删除失败!Error=" + flg, 'info');
					}
				} 
			});
		}else{
			//本院外送 ID为检验报告的ID##class(DHCHAI.DP.LabVisitReport).GetReportByID(LabReportDr)
			$.messager.confirm("删除", "确认是否删除?", function (r) {
				if (r) {				
					var flg = $m({
						ClassName:"DHCHAI.IRS.OutLabReportSrv",
						MethodName:"CancelOutLabRep",
						aLabReportDr:ID
					},false);
					
					if (parseInt(flg)>=0){
						$.messager.popover({msg: '删除成功！',type:'success',timeout: 1000});
						obj.btnClear_click();
						obj.reloadOutLabRegList();
					} else {
						$.messager.alert("错误提示","删除失败!Error=" + flg, 'info');
					}
				} 
			});
		}
	}
	//重新加载表格数据
	obj.reloadOutLabRegList = function(){
		$('#OutLabRegList').datagrid('load',{
			 ClassName:'DHCHAI.IRS.OutLabReportSrv',
		     QueryName:'QryOutLabRep',
		     aEpisodeID:obj.EpisodeID
		});
		$('#OutLabRegList').datagrid('unselectAll');
	};
	//病原学检验提取弹出事件
	obj.LayerOpenINFLabSync = function() {
		$HUI.dialog('#LayerOpenINFLabSync',{
			title:"病原学检验-提取 [双击数据进行编辑]", 
			iconCls:'icon-w-paper',
			width: 1080,    
			height: 500, 
			modal: true,
			isTopZindex:true
		});
	}
	// 弹出病原学检验提取框
	obj.OpenINFLabSync = function(){
		obj.refreshgridINFLabSync();
		$('#LayerOpenINFLabSync').show();
		obj.LayerOpenINFLabSync();
	}
	//病原学检验列表
	obj.refreshgridINFLabSync = function(){	
		obj.gridINFLabSync = $HUI.datagrid("#gridINFLabSync",{
			fit:true,
			headerCls:'panel-header-gray',
			iconCls:'icon-paper',
			rownumbers: true, //如果为true, 则显示一个行号列
			singleSelect: true,
			fitColumns: true,
			loadMsg:'数据加载中...',
			url:$URL,
			queryParams:{
				ClassName:'DHCHAI.IRS.INFLabSrv',
				QueryName:'QryLabVisitByEpsID',
				aEpisodeID:obj.EpisodeID,
				rows:9999
			},
			columns:[[
				{field:'TSDesc',title:'检验医嘱',width:200},
				{field:'Specimen',title:'标本',width:100},
				{field:'SubmissLoc',title:'送检科室',width:120},
				{field:'SubmissDate',title:'送检日期',width:100},
				{field:'AssayMethod',title:'检验方法',width:100},
				{field:'PathogenTest',title:'病原学检验结果',width:150},
				{field:'Bacterias',title:'病原体',width:300,
					formatter: function(value,row,index){
						if (obj.Bacterias) {
							var arrBacteria = obj.Bacterias.split(",");
							var len = arrBacteria.length;
							for (var i=0;i<len;i++) {
								var Bacteria=arrBacteria[i];
							    if (value.indexOf(Bacteria)>-1) {
								    value ="<div style='padding:5px;'><span style='background-color:#00CDCD;border-radius:5px;color:#fff;text-align:left;padding:3px;' >"+value+"</span></div>";
							    }
							}
							return value;
						}else {
							return value;
						}
					}
				}
			]],	
			onDblClickRow:function(rindex, rowdata) {
				if (rindex>-1) {
					obj.InitLabData(rowdata,'');
					$HUI.dialog('#LayerOpenINFLabSync').close();
				}
			}		
		});		
	}
	// 初始化数据
	obj.InitLabData=function(d,r){
		// 控件赋值
		if (d){
			obj.TestSetID  = d.TestSetID;
			obj.SpecimenID = d.SpecimenID;
			obj.VisitNumID = d.VisitNumberDr;
			obj.LabRepID   = d.LabRepID;
			$('#cboTestSet').lookup('setText',d.TSDesc);
			$('#cboSpecimen').lookup('setText',d.Specimen);
			$('#SubmissDate').datebox('setValue',d.SubmissDate);
		}else {			
			$('#cboTestSet').lookup('setText',''); 	
			$('#cboSpecimen').lookup('setText','');
			$('#SubmissDate').datebox('clear');
		}
	}
	
	//病人列表弹出事件
	obj.LayerOpenPatList = function() {
		$HUI.dialog('#LayerOpenPatList',{
			title:"病人列表 [双击数据进行编辑]", 
			iconCls:'icon-w-paper',
			width: 780,    
			height: 400, 
			modal: true,
			isTopZindex:true
		});
	}
	// 弹出病人列表框
	obj.OpenPatList = function(){
		obj.refreshgridPatList();
		$('#LayerOpenPatList').show();
		obj.LayerOpenPatList();
	}
	//病人列表
	obj.refreshgridPatList = function(){
		var PatValue = $("#txtPatName").val();	
		obj.gridPatList = $HUI.datagrid("#gridPatList",{
			fit:true,
			headerCls:'panel-header-gray',
			iconCls:'icon-paper',
			rownumbers: true, //如果为true, 则显示一个行号列
			singleSelect: true,
			fitColumns: true,
			loadMsg:'数据加载中...',
			url:$URL,
			queryParams:{
				ClassName:'DHCHAI.DPS.PAAdmSrv',
				QueryName:'QryAdmInfoByName',
				aIntputs:PatValue,
				rows:9999
			},
			columns:[[
				{field:'PatName',title:'姓名',width:200},
				{field:'MrNo',title:'病案号',width:180},
				{field:'PapmiNo',title:'登记号',width:200},
				{field:'Sex',title:'性别',width:120},
				{field:'AdmDate',title:'就诊日期',width:120}
			]],	
			onDblClickRow:function(rindex, rowdata) {
				if (rindex>-1) {
					obj.InitPatData(rowdata,'');
					$HUI.dialog('#LayerOpenPatList').close();
				}
			}		
		});		
	}
	// 初始化数据
	obj.InitPatData=function(d,r){
		if (d){
			obj.ELEnable();
			obj.EpisodeID = d.EpisodeID;
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
			obj.reloadOutLabRegList();
		}
	}
}

