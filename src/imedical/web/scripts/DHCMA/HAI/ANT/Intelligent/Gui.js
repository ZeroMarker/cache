//页面Gui
var objScreen = new Object();
function InitAntMoniWin(){
	var obj = objScreen;
	var LogonHospID = $.LOGON.HOSPID;
	
	obj.dtDateTo	= $('#dtDateTo').datebox('setValue', Common_GetDate(new Date()));
	obj.dtDateFrom	= $('#dtDateFrom').datebox('setValue', Common_GetDate(new Date()));
	
	//医院 科室
	obj.cboHospital=Common_ComboToSSHosp("cboHospital",LogonHospID);
	$HUI.combobox('#cboHospital',{
	    onSelect:function(rows){
		    var HospID=rows["ID"];
			obj.cboRepLoc=Common_ComboToLoc("cboLoc",HospID,"","I","E");//E|W
	    }
    });
	
	obj.gridAntMonitor = $HUI.datagrid("#AntMonitor",{
		fit: true,
		title:'抗菌用药患者列表',
		headerCls:'panel-header-gray',
		iconCls:'icon-resort',
		pagination: true, //如果为true, 则在DataGrid控件底部显示分页工具栏
		rownumbers: true, //如果为true, 则显示一个行号列
		singleSelect: true,	
		fitColumns: true,	
		loadMsg:'数据加载中...',
		pageSize: 20,
		pageList : [20,50,100,200],
		nowrap:false,	   
		url:$URL,
	    queryParams:{
			ClassName:'DHCHAI.ANTS.OrdAntiPatSrv',
			QueryName:'QryIntMonitor',
			aHospIDs:$('#cboHospital').combobox('getValue'),
			aDateFrom:$('#dtDateFrom').datebox('getValue'),
			aDateTo:$('#dtDateTo').datebox('getValue'),
			alocDr:$('#cboLoc').combobox('getValue'),
			aAntiMastDr:$('#cboAntiMast').combobox('getValue'),
			aQryStatus:$('#cboQryStatus').combobox('getValue'),
			aPatNo:$('#txtRegNo').val()			
	    },
		columns:[[
			{field:'PatNo',title:'登记号',width:120,align:'center'},
			{field:'PatName',title:'姓名',width:80,align:'center',sortable:'true'},
			{field:'PatSex',title:'性别',width:50,align:'center'},
			{field:'PatAge',title:'年龄',width:80,align:'center',sortable:'true'},
			{field:'AdmLocDesc',title:'就诊科室',width:150,align:'center',sortable:'true'},
			{field:'AdmWardDesc',title:'就诊病区',width:180,align:'center',sortable:'true'},
			{field:'AdmBed',title:'床位',width:50,align:'center'},
			{field:'AdmDate',title:'入院日期',width:100,align:'center',sortable:'true'},
			{field:'DischDate',title:'出院日期',width:100,align:'center',sortable:'true'},
			{field:'IsReport',title:'是否上报',width:80,align:'center',sortable:'true'},
			{field:'VisitStatus',title:'就诊状态',width:80,align:'center',sortable:'true'},
			{field:'DrugNameList',title:'用药情况',width:150,align:'center',
				formatter: function(value,row,index){
					var strList = value.split(",");
					var len = strList.length;	   
					var strRet ="";
					for (var indx=0;indx<len;indx++){
						var DrugName =strList[indx].split(",");
						strRet +="<div style='padding:5px;'><span style='background-color:#00CDCD;border-radius:5px;color:#fff;text-align:left;padding:3px;' >"+DrugName+"</span></div>";
					}
					return strRet;
				}
			}
		]]
		,view: detailview
		,detailFormatter:function(index, rowData){	
			return '<div style="padding:5px 5px 5px 0px;"><table id=gridAntiDrugList'+index+'></table></div>';
		}, 
		onExpandRow: function(pindex, rowData){
			var rows = $('#AntMonitor').datagrid('getRows');
			$.each(rows,function(i,k){
				//获取当前所有展开的子网格
				var expander = $('#AntMonitor').datagrid('getExpander',i);
				if(expander.length && expander.hasClass('datagrid-row-collapse')){
					if(k.EpisodeID != rowData.EpisodeID){
						//折叠上一次展开的子网格
						$('#AntMonitor').datagrid('collapseRow',i);
					}
				}
			});
		
			obj.gridAntiDrugList = $HUI.datagrid('#gridAntiDrugList'+pindex,{   //患者用药明细
				fitColumns: true,		
				pageSize: 5,
				pageList : [5,10],
				pagination: true, //如果为true, 则在DataGrid控件底部显示分页工具栏			
				singleSelect: true,
				autoRowHeight: true,
				rownumbers: true,
				loadMsg:'数据加载中...',
				url:$URL,
				queryParams:{
					ClassName:"DHCHAI.ANTS.OrdAntiPatSrv",
					QueryName:"QryPatSta",		
					aEpisodeID:rowData.EpisodeID
				},
				columns:[[
					{field:'OEOrdDesc',title:'医嘱名',width:220},
					{field:'AntiMastDesc',title:'标准名称',width:150,
						formatter: function(value,row,index){					
							return "<div style='padding:5px;'><span style='background-color:#00CDCD;border-radius:5px;color:#fff;text-align:left;padding:3px;' >"+value+"</span></div>";					 
						}
					},
					{field:'OESttDate',title:'医嘱开始日期',width:100},
					{field:'OEXDate',title:'停医嘱日期',width:100},
					{field:'OEOrdLoc',title:'开医嘱科室',width:100},
					{field:'OEDoseQty',title:'剂量',width:50},
					{field:'OEDoseQtyUom',title:'单位',width:60},
					{field:'OEFreqDesc',title:'频次',width:50},
					{field:'OEInstruc',title:'用法',width:100},
					{field:'OEDoctor',title:'主治医师',width:100},
					{field:'RepStatus',title:'报告状态',width:80},
					{field:'ReportStr',title:'上报记录',width:300,
						formatter: function(value,row,index){
							var strRet = "";
							if (value != ''){
								var strList = value.split("$$");
								var len = strList.length;
								for (var indx=0;indx<len;indx++){
									var arrInfo = strList[indx].split(",");
									var RepID = arrInfo[0];
									var RepAnti = arrInfo[1];
									var RepDate = arrInfo[2];
									var RepTime = arrInfo[3];
									var Status = arrInfo[4];
									strRet +="<div style='padding:5px;'><span style='background-color:#00CDCD;border-radius:5px;color:#fff;text-align:left;padding:3px;' >"
									+ "<a href='#' style='white-space:normal; color:#FFFFFF' onclick='objScreen.btnReport_Click(\"" + rowData.EpisodeID + "\",\"" + RepID + "\",\"" + row.OrdItemID + "\",\"" + pindex + "\");'>"+ RepAnti + ' ' + RepDate + ' ' + RepTime + ' ' + Status + "</a>"
									+"</span></div>";
								}
							} else {
								strRet=" <a href='#' style='white-space:normal; color:blue' onclick='objScreen.btnReport_Click(\"" + rowData.EpisodeID + "\",\"" + "" + "\",\"" + row.OrdItemID + "\",\"" + pindex + "\");'><u>上报</u></a>";
							}
						
							return strRet;
						}
					}
				]],
				onResize: function () {
					$('#AntMonitor').datagrid('fixDetailRowHeight', pindex);
				},
				onLoadSuccess: function (data) {
					setTimeout(function () {
						$('#AntMonitor').datagrid('fixDetailRowHeight', pindex);
					}, 0);
				}				
			});
		},
		onClickCell: function(rindex,field,value){  //刷新设置选中后执行两遍，换成onClickCell
			if(field!="_expander"){
				var expander = $('#AntMonitor').datagrid('getExpander',rindex);  //获取展开行
				if(expander.length && expander.hasClass('datagrid-row-collapse')){
					$('#AntMonitor').datagrid('collapseRow',rindex); //折叠
				} else {
					$('#AntMonitor').datagrid('expandRow',rindex);   //展开		
				}	
			}
		},rowStyler: function(index,row){
			var ReportStr = row.ReportStr;
			if(ReportStr!=""){
				var strList = ReportStr.split("$$");
				var len = strList.length;
				var Flag=0;			
				for (var indx=0;indx<len;indx++){
					var arrInfo = strList[indx].split(",");
					var Status = arrInfo[4];
					if (Status=="退回"){
						Flag=Flag+1;
					}
				}
				if(Flag>0){
					return 'color:#FF34B3;'; 
				}
			}
		}
	});
	//状态
	$HUI.combobox("#cboQryStatus", {
		editable:true,
		defaultFilter:4,
		valueField: 'ID',
		textField: 'DicDesc',
		onShowPanel:function(){
			var url=$URL+"?ClassName=DHCHAI.BTS.DictionarySrv&QueryName=QryDic&ResultSetType=array&aTypeCode=ANTStatus&aActive=1";
			$("#cboQryStatus").combobox('reload',url);	
		}
	});
	
	//抗菌用药
	$HUI.combobox("#cboAntiMast", {
		editable:true,
		defaultFilter:4,
		valueField: 'AntiMastID',
		textField: 'AntiMastDesc',
		onShowPanel:function(){
			var url=$URL+"?ClassName=DHCHAI.IRS.CRuleAntiSrv&QueryName=QryCRuleAnti&ResultSetType=array";
			$("#cboAntiMast").combobox('reload',url);	
		}
	});
	
	InitAntMoniWinEvent(obj);
	obj.LoadEvent(arguments);
	return obj;
}