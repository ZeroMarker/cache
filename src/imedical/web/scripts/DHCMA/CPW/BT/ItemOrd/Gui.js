//页面Gui
function InitHISUIWin(){
	var obj = new Object();
	obj.isCNMedItem=0;
	obj.Arcim=""
	obj.btnAdd=$HUI.linkbutton("#addIcon",{
		iconCls:'icon-add',
		plain:true,
		text:'新增'
	});
	obj.btnEdit=$HUI.linkbutton("#editIcon",{
		iconCls:'icon-write-order',
		plain:true,
		text:'修改'
	});
	obj.btnDel=$HUI.linkbutton("#delIcon",{
		iconCls:'icon-cancel',
		plain:true,
		text:'删除'
	});
	$('#winFJ').dialog({
		title: '方剂关联',
		iconCls:"icon-w-edit",
		closed: true,
		modal: true
	});
	$("#editIcon").linkbutton("disable");
	$("#delIcon").linkbutton("disable");
	$("#addIcon").linkbutton("enable");
	//初始化赋值	
	obj.cboOrdTypeDr = $HUI.combobox("#cboOrdTypeDr",{
		url:$URL+"?ClassName=DHCMA.Util.BTS.DictionarySrv&QueryName=QryDictByType&aTypeCode=CPWFormOrdType&ResultSetType=array",
		valueField:'BTID',
		textField:'BTDesc',
		required:true
		,onLoadSuccess:function()
		{
			obj.CboSelectByText("cboOrdTypeDr","01");
		}
		,onSelect:function(v){
			if (v.BTDesc.indexOf("方剂")>-1) {
				$HUI.dialog('#winFJ').open();	
			}
		}
	});
	obj.gridItemFJ = $HUI.datagrid("#gridItemFJ",{
		pagination: false, //如果为true, 则在DataGrid控件底部显示分页工具栏
		rownumbers: false, //如果为true, 则显示一个行号列
		singleSelect: false,
		nowrap:false,
		autoRowHeight: false, //定义是否设置基于该行内容的行高度。设置为 false，则可以提高加载性能
		loadMsg:'数据加载中...',
		fit: true,
		pagination: true, //如果为true, 则在DataGrid控件底部显示分页工具栏
		pageSize: 20,
		pageList : [20,50,100,200],
		url:$URL,		
		queryParams:{
			ClassName:"DHCMA.CPW.BTS.PathFormTCMSrv",
			QueryName:"QryPathFormTCM",
			aFormItem:ParamID
		},
		columns:[[
			{field:'checked',checkbox:'true'},
			{field:'SympTCMDesc',title:'中药方剂',width:'130',sortable:'true'},
			{field:'SympDiagnos',title:'症候诊断',width:'300',sortable:'true'},
			{field:'ActDate',title:'操作日期',width:'100',sortable:'true'},
			{field:'ActUserDesc',title:'操作人',width:'110',sortable:'true'}
		]],
		onSelect:function(rindex,rowData){
			if (rindex>-1) {
			}
		},
		onCheck:function(rindex,rowData){
			var Parref=ParamID
			var TCMDr=rowData.SympTCMDr
			var UserID=session['DHCMA.USERID']
			var aInputStr=Parref+"^^"+TCMDr+"^^^"+UserID
			$m({
				ClassName:"DHCMA.CPW.BT.PathFormTCM",
				MethodName:"Update",
				aInputStr:aInputStr
				},function(data){
					obj.gridItemFJ.load({
							ClassName:"DHCMA.CPW.BTS.PathFormTCMSrv",
							QueryName:"QryPathFormTCM",
							aFormItem:ParamID
					});
				})
			},
		onUncheck:function(rindex,rowData){
			$m({
				ClassName:"DHCMA.CPW.BT.PathFormTCM",
				MethodName:"DeleteById",
				aId:rowData.FormTCMID
			},function(data){
				$("#gridItemFJ").datagrid("updateRow",{  
        	       index:rindex, //行索引  
            	   row:{  
                		 FormTCMID:'',
                		 ActDate:'',
                		 ActUserDesc:'',
                		 checked:0
                	  }  
 		 		})
			})	
		},
		onLoadSuccess:function(data){
			$(".datagrid-header-check").html("");
			var rLength=data.rows.length
			for (var i=0;i<rLength;i++) {
				var rowData=data.rows[i]
				if (rowData.Linked==1) {
					$("#gridItemFJ").datagrid("updateRow",{  
	        	       index:i, //行索引  
	            	   row:{  
	                		 checked:1
	                	  }  
	 		 		})
				}
			}
		}
	});
	//初始化赋值	
	obj.cboOrdPriorityID = $HUI.combobox("#cboOrdPriorityID",{
		url:$URL+"?ClassName=DHCMA.CPW.BTS.LinkArcimSrv&QueryName=QryOECPriority&ResultSetType=array",
		valueField:'OECPRID',
		textField:'OECPRDesc',
		required:true
	});	
	
	obj.IsCheckIndex = -1; 
	obj.gridItemOrd = $HUI.datagrid("#gridItemOrd",{
		fit: true,
		headerCls:'panel-header-gray',
		iconCls:'icon-star-light-yellow',
		toolbar:'#tb', //配置项toolbar为空时,会在标题与列头产生间距"
		pagination: true, //如果为true, 则在DataGrid控件底部显示分页工具栏
		rownumbers: true, //如果为true, 则显示一个行号列
		singleSelect: true,
		sortName: 'OrdLnkOrdDr',
		sortOrder: 'asc',
		autoRowHeight: false, //定义是否设置基于该行内容的行高度。设置为 false，则可以提高加载性能
		loadMsg:'数据加载中...',
		pageSize: 20,
		pageList : [20,50,100,200],
	    url:$URL,
	    queryParams:{
		    ClassName:"DHCMA.CPW.BTS.PathFormEpSrv",
			QueryName:"QryPathFormEpItemOrd",
			aPathFormEpItemDr:ParamID
	    },
		columns:[[
			{field:'OrdTypeDrDesc',title:'分类标记',width:'70'},
			{field:'OrdGeneIDDesc',title:'通用名',width:'150'},
			{field:'OrdPriorityIDDesc',title:'医嘱类型',width:'70'},
			{field:'OrdLnkOrdDr',title:'关联号',width:'70'},
			{field:'OrdMastIDDesc',title:'医嘱名',width:'200'},
			{field:'OrdDoseQty',title:'单次剂量',width:'70'},
			{field:'OrdUOMIDDesc',title:'单位',width:'70'},
			{field:'OrdFreqIDDesc',title:'频次',width:'70'},
			{field:'OrdInstrucIDDesc',title:'用法',width:'70'},
			{field:'OrdDuratIDDesc',title:'疗程',width:'70'},
			{field:'OrdQty',title:'数量',width:'60'},
			{field:'OrdQtyUOMDesc',title:'数量单位',width:'70'},
			{field:'OrdIsDefault',title:'首选医嘱',width:'70',
			  editor:
			  {
				  type:'switchbox',options:{onClass:'primary',offClass:'gray',onText:'是',offText:'否'
											,onSwitchChange:function(event,value){
													// true false console.log(value);
													var tr = $(this).closest('tr');
													//paseInt(tr.attr("datagrid-row-index"));										
													var selData = $('#gridItemOrd').datagrid('getSelected');
													
													var aInput = ParamID+"||"+selData["ID"]+"^"+(value.value?"1":"0")+"^^^"+session['DHCMA.USERID'];
													obj.saveToEntiy(aInput);
												}
										   }
			  }
			},
			{field:'OrdIsFluInfu',title:'是否主医嘱',width:'70',
			  editor:
			  {
				  type:'switchbox',options:{onClass:'primary',offClass:'gray',onText:'是',offText:'否'
											,onSwitchChange:function(event,value){
													// true false console.log(value);
													var tr = $(this).closest('tr');
													//paseInt(tr.attr("datagrid-row-index"));										
													var selData = $('#gridItemOrd').datagrid('getSelected');													
													var aInput = ParamID+"||"+selData["ID"]+"^^"+(value.value?"1":"0")+"^^"+session['DHCMA.USERID'];
													obj.saveToEntiy(aInput);
												}
										   }
			}},
			{field:'OrdIsActive',title:'是否有效',width:'70',
			  editor:
			  {
				  type:'switchbox',options:{onClass:'primary',offClass:'gray',onText:'是',offText:'否'
											,onSwitchChange:function(event,value){
													// true false console.log(value);
													var tr = $(this).closest('tr');
													//paseInt(tr.attr("datagrid-row-index"));										
													var selData = $('#gridItemOrd').datagrid('getSelected');
													
													var aInput = ParamID+"||"+selData["ID"]+"^^^"+(value.value?"1":"0")+"^"+session['DHCMA.USERID'];
													obj.saveToEntiy(aInput);
												}
										   }
			}},
			{field:'OrdNote',title:'备注',width:'70'}
		]],
		onBeforeLoad: function (param) {
            //var firstLoad = $(this).attr("firstLoad");
            
		},
		onSelect:function(rindex,rowData){			
			if (rindex>-1) {
				var p = obj.gridItemOrd.getPanel();
				p.find("#addIcon").linkbutton("enable",false);
				p.find("#editIcon").linkbutton("enable",false);
				p.find("#delIcon").linkbutton("enable",false);
				obj.selRowDataView();
				$("#editIcon").linkbutton("enable");
				$("#delIcon").linkbutton("enable");
				$("#addIcon").linkbutton("disable");
			}
			
		},
		onUncheck:function(rindex,rowData){
			$("#editIcon").linkbutton("disable");
			$("#delIcon").linkbutton("disable");
			$("#addIcon").linkbutton("enable");
		},
		onClickRow: function(rowIndex,rowData){//增加点击选中，再次点击取消选中 by wjf
			if(obj.IsCheckIndex == rowIndex){//再次点击该行 
				$("#gridItemOrd").datagrid("unselectRow", rowIndex)
				.datagrid('endEdit', rowIndex);	
				obj.IsCheckIndex = -1;
				$("#cboOrdTypeDr").combobox("setValue","");
				$("#itemOrdID").val("");
				$("#txtOrdMastIDH").val("");
				$("#txtOrdMastID").val("");
				$("#itemOrdGeneID").val("");
				$("#cboOrdPriorityID").combobox("setValue","");
				$("#txtOrdQty").val("");
				$("#cboOrdFreqID").val("");
				$("#cboOrdDuratID").val("");
				$("#cboOrdInstrucID").val("");
				$("#txtOrdFreqIDH").val("");
				$("#txtOrdDuratIDH").val("");
				$("#txtOrdInstrucIDH").val("");
				$("#txtOrdDoseQty").val("");
				$("#cboOrdUOMID").combobox("setValue","");
				$("#txtOrdNote").val("");
				$("#txtOrdLnkOrdDr").val(""); 
				$("#txtOrdPos").val("");
			}else if(obj.IsCheckIndex != -1){//点击其他行
				$("#gridItemOrd").datagrid("unselectRow", obj.IsCheckIndex)
				.datagrid('endEdit', obj.IsCheckIndex);	
				$('#gridItemOrd').datagrid('selectRow', rowIndex)
				.datagrid('beginEdit', rowIndex);	
				obj.IsCheckIndex = rowIndex;
			}else{		
				$('#gridItemOrd').datagrid('selectRow', rowIndex)
				.datagrid('beginEdit', rowIndex);	
				obj.IsCheckIndex = rowIndex;	
			}		
		},
		onAfterEdit:function(rowIndex, rowData, changes){
			
		}
		
	});
	 	
	$("#txtOrdMastID").lookup({
		width:340,
		panelWidth:500,
		url:$URL,	//+"?ClassName=DHCMA.CPW.BTS.LinkArcimSrv&QueryName=QryArcimByAlias&ResultSetType=array",
		mode:'remote',
		method:"Get",
		idField:'ArcimID',
		textField:'ArcimDesc',
		columns:[[  
			{field:'ArcimCode',title:'代码',width:100},  
			{field:'ArcimDesc',title:'描述',width:300},  
			{field:'ArcimID',title:'ID',width:70}  
		]],
		pagination:true,
		isCombo:true,
		minQueryLen:2,
		delay:'500',
		queryOnSameQueryString:true,
		queryParams:{ClassName:'DHCMA.CPW.BTS.LinkArcimSrv',QueryName:'QryArcimByAlias',aHospID:session['DHCMA.HOSPID']},
		onSelect:function(index,rowData){
			obj.Arcim = rowData
			//console.log("index="+index+",rowData=",rowData);
			//检查是否是草药类医嘱
			obj.isCNMedItem=$cm({
				ClassName:"DHCMA.CPW.IO.FromDoc",
				MethodName:"IsCPWCNMedItem",
				aArcimRowid:rowData.ArcimID
			},false);
			//检查医嘱是否有检查部位选择  dsp
			var OrdBodyStr = $cm({
				ClassName:"web.DHCAPPExaReportQuery",
				MethodName:"jsonGetPartTreeByArc",
				itmmastid:rowData.ArcimID,
				PyCode:"",
				TraID:"",
				HospID:session['LOGON.HOSPID'],
				dataType:"text"
			},false);
			
			if(OrdBodyStr.indexOf("id")>0){		
					var path="dhcapp.appreppartwin.csp?itmmastid="+rowData.ArcimID+"&selOrdBodyPartStr=*";
					/*var ret=window.showModalDialog(
						path,
						"",
						"dialogHeight: 500px; dialogWidth: 800px");
					if((ret!="")&&(ret!=undefined)){
						var arrPos=ret.split("^")
						var strPos=arrPos[0]+"||"+arrPos[1];
						$("#txtOrdPos").val(strPos);
					}*/
					websys_showModal({
						url:path,
						title:'添加检查部位',
						iconCls:'icon-w-import',  
						closable:false,
						originWindow:window,
						width:800,
						height:500,
						CallBackFunc:function(ret){
							if((ret!="")&&(ret!=undefined)){
								var arrPos=ret.split("^")
								var strPos=arrPos[0]+"||"+arrPos[1]+"||"+arrPos[2];
								$("#txtOrdPos").val(strPos);
							}
						}
					});
			}
			obj.OrdMastSelect(rowData);
		}
	});
	$("#cboOrdFreqID").lookup({
		panelWidth:140,
		url:$URL,//+"?ClassName=DHCMA.CPW.BTS.LinkArcimSrv&QueryName=QryPHCFreq&ResultSetType=array",
		mode:'remote',
		method:"Get",
		isCombo:true,
		//minQueryLen:2,
		selectOnNavigation: true,
		pagination:false,
		delay:'500',
		queryOnSameQueryString:true,
		idField:'FreqID',
		textField:'FreqDesc',
		queryParams:{ClassName:'DHCMA.CPW.BTS.LinkArcimSrv',QueryName:'QryPHCFreq'},
		columns:[[  
			{field:'FreqID',title:'ID',width:50,sortable:true,hidden:true},  
			{field:'FreqDesc',title:'描述',width:120,sortable:true}, 
		]],
		onSelect:function(index,rowData){
			$("#txtOrdFreqIDH").val(rowData['FreqID']);
		}
	});
	//keyup事件(为空时取值)
	$("#cboOrdFreqID").on('keyup',function() {
		if ($(this).val()=='') {
			$('#txtOrdFreqIDH').val('');
		}
	});

	$("#cboOrdInstrucID").lookup({
		panelWidth: 140,
		url: $URL,	//+"?ClassName=DHCMA.CPW.BTS.LinkArcimSrv&QueryName=QryPHCInstruc&ResultSetType=array",
		mode: 'remote',
		method:"Get",
		isCombo: true,
		//minQueryLen: 2,
		selectOnNavigation: true,
		pagination: false,
		delay:'500',
		queryOnSameQueryString:true,
		idField: 'InstrucID',
		textField: 'InstrucDesc',
		queryParams:{ClassName:'DHCMA.CPW.BTS.LinkArcimSrv',QueryName:'QryPHCInstruc'},
		columns: [[  
			{field:'InstrucID',title:'ID',width:50,hidden:true},  
			{field:'InstrucDesc',title:'描述',width:120}, 
		]],
		onSelect : function(index,rowData){
			$("#txtOrdInstrucIDH").val(rowData['InstrucID']);
		},
		onBeforeLoad : function(param){
			if ($("#txtOrdMastID").val() == '') {
				$.messager.popover({msg: '请先选择医嘱项',type:'info',timeout: 2000,showType: 'show'});
				$("#cboOrdInstrucID").lookup('hidePanel');
				return false;
			}
			param.OrdID = obj.Arcim.ArcimID;
			param.Instruc = param.q;
			
			//param = $.extend(param,{OrdID:obj.Arcim.ArcimID,Instruc:param.q});
		}
	});
	//keyup事件(为空时取值)
	$("#cboOrdInstrucID").on('keyup',function() {
		if ($(this).val()=='') {
			$('#txtOrdInstrucIDH').val('');
		}
	});
	
	$("#cboOrdDuratID").lookup({
		panelWidth:140,
		url:$URL,	//+"?ClassName=DHCMA.CPW.BTS.LinkArcimSrv&QueryName=QryPHCDuration&ResultSetType=array",
		mode:'remote',
		method:"Get",
		isCombo:true,
		//minQueryLen:2,
		selectOnNavigation: true,
		pagination: false,
		delay:'500',
		queryOnSameQueryString:true,
		idField:'DuratID',
		textField:'DuratDesc',
		queryParams:{ClassName:'DHCMA.CPW.BTS.LinkArcimSrv',QueryName:'QryPHCDuration'},
		columns:[[  
			{field:'DuratID',title:'ID',width:50,hidden:true},  
			{field:'DuratDesc',title:'描述',width:120}, 
		]],
		onSelect:function(index,rowData){
			$("#txtOrdDuratIDH").val(rowData['DuratID']);
		}
	});
	//keyup事件(为空时取值)
	$("#cboOrdDuratID").on('keyup',function() {
		if ($(this).val()=='') {
			$('#txtOrdDuratIDH').val('');
		}
	});
	InitHISUIWinEvent(obj);
	obj.LoadEvents(arguments);
	return obj;
}
