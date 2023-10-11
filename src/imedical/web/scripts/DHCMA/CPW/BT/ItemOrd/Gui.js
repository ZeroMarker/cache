//页面Gui
function InitHISUIWin(){
	var obj = new Object();
	obj.curFormOrdID="";
	obj.isCNMedItem=0;
	obj.Arcim="";
	obj.isModified = false;
	obj.isLongOrdType=0;
	obj.cfgModifyVal="";	// 获取配置参数，是否允许发布后再修改医嘱
	
	obj.CurrEpDays=$cm({					//当前阶段天数
		ClassName:"DHCMA.CPW.BTS.PathFormEpSrv",
		MethodName:"GetCurFormEpDays",
		aFormItemID:ParamID
	},false);
	
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
	obj.btnMoveUp=$HUI.linkbutton("#moveUp",{
		iconCls:'icon-arrow-top',
		plain:true,
		text:'上移'
	});
	obj.btnMoveDown=$HUI.linkbutton("#moveDown",{
		iconCls:'icon-arrow-bottom',
		plain:true,
		text:'下移'
	});
	obj.btnDel=$HUI.linkbutton("#saveSeq",{
		iconCls:'icon-save',
		plain:true,
		text:'保存顺序'
	});
	$("#editIcon").linkbutton("disable");
	$("#delIcon").linkbutton("disable");
	$("#addIcon").linkbutton("enable");
	$("#moveUp").linkbutton("disable");
	$("#moveDown").linkbutton("disable");
	$("#saveSeq").linkbutton("disable");
	//初始化赋值	
	obj.cboOrdTypeDr = $HUI.combobox("#cboOrdTypeDr",{
		url:$URL+"?ClassName=DHCMA.Util.BTS.DictionarySrv&QueryName=QryDictByType&aTypeCode=CPWFormOrdType&aHospID="+CurrHosp+"&ResultSetType=array",
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
			aFormItem:ParamID,
			aHospID:CurrHosp
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
							aFormItem:ParamID,
							aHospID:CurrHosp
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
		required:true,
		onSelect:function(row){
			//长期医嘱类型（含长期医嘱、自备药长期、长期嘱托）数量不可编辑、天数可编辑
			//否则数量可编辑、天数不可编辑
			if (row.OECPRCode!="S" && row.OECPRCode!="OMST" && row.OECPRCode!="OMCQZT"){		//临时医嘱、出院医嘱
				$("#txtOrdQty").validatebox("setDisabled",false);
				$("#txtOrdUseDays").validatebox("setDisabled",true);
				$("#txtOrdUseDays").val("");
				obj.isLongOrdType=0	
			}else{																				//长期医嘱
				$("#txtOrdQty").validatebox("setDisabled",true);
				$("#txtOrdUseDays").validatebox("setDisabled",false);
				var selGridRow = $('#gridItemOrd').datagrid('getSelected');
				if(selGridRow == null || selGridRow == undefined){
					if (obj.Arcim!="" && obj.Arcim.ArcimID.indexOf("||")!=-1){		//医嘱项
						//为天数设置初始值取当前阶段天数
						$("#txtOrdUseDays").val(obj.CurrEpDays);
					}else{																					//医嘱套
						$("#txtOrdUseDays").val("")	
					}	
				}				
				obj.isLongOrdType=1;
			}
		}
	});	
	
	obj.IsCheckIndex = -1; 
	obj.gridItemOrd = $HUI.datagrid("#gridItemOrd",{
		fit: true,
		headerCls:'panel-header-gray',
		iconCls:'icon-star-light-yellow',
		toolbar:'#tb', //配置项toolbar为空时,会在标题与列头产生间距"
		// 涉及到对关联医嘱项的排序问题，若涉及分页，跳页进行排序太麻烦了...
		pagination: true, //如果为true, 则在DataGrid控件底部显示分页工具栏
		rownumbers: true, //如果为true, 则显示一个行号列
		singleSelect: true,
		remoteSort:false,
		sortName: 'SeqCode',
		sortOrder: 'asc',
		autoRowHeight: false, //定义是否设置基于该行内容的行高度。设置为 false，则可以提高加载性能
		loadMsg:'数据加载中...',
		pageSize: 200,
		pageList : [200,500,1000,2000],
	    url:$URL,
	    queryParams:{
		    ClassName:"DHCMA.CPW.BTS.PathFormEpSrv",
			QueryName:"QryPathFormEpItemOrd",
			aPathFormEpItemDr:ParamID
	    },
		columns:[[
			{field:'SeqCode',title:'序号',width:'70',hidden:true,sortable:true,sorter:Sort_int},
			{field:'OrdTypeDrDesc',title:'分类标记',width:'70'},
			{field:'OrdGeneIDDesc',title:'通用名',width:'150'},
			{field:'OrdPriorityIDDesc',title:'医嘱类型',width:'70'},
			{field:'OrdLnkOrdDr',title:'<span title=\"关联规则按1、1.1、1.2...维护\" class=\"hisui-tooltip\">关联号</span>',width:'70'},
			{field:'OrdMastIDDesc',title:'医嘱名',width:'200',formatter:function(value,row,index){			
				if (row.OrdMastID.split("||").length!=2){					
					var ARCOSRowid=row.OrdMastID;
					return value+"<label style='color:red;' onclick=ShowARCOSDetail("+ARCOSRowid+")>[明细]</label>"	
				}else{
					return value;
				}
			}},
			{field:'OrdDoseQty',title:'单次剂量',width:'70'},
			{field:'OrdUOMIDDesc',title:'单位',width:'70'},
			{field:'OrdFreqIDDesc',title:'频次',width:'70'},
			{field:'OrdInstrucIDDesc',title:'用法',width:'70'},
			{field:'OrdDuratIDDesc',title:'疗程',width:'70'},
			{field:'OrdUseDays',title:'天数(天)',width:'70'},
			{field:'OrdQty',title:'数量',width:'60'},
			{field:'OrdQtyUOMDesc',title:'数量单位',width:'70'},
			{field:'OrdIsDefault',title:'<span title=\"开立医嘱时是否默认勾选\" class=\"hisui-tooltip\">首选医嘱</span>',width:'70',
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
			{field:'OrdIsFluInfu',title:'<span title=\"主医嘱执行，所属项目才会执行\" class=\"hisui-tooltip\">是否主医嘱</span>',width:'70',
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
			{field:'OrdNote',title:'备注',width:'70'},
			{field:'SeqCode',hidden:true}
		]],
		onBeforeLoad: function (param) {
            //var firstLoad = $(this).attr("firstLoad");
            
		},
		onSelect:function(rindex,rowData){
			if (obj.cfgModifyVal == "Y") return;		// 发布后禁止修改关联医嘱则点击不进入编辑状态
						
			if (rindex>-1) {
				var p = obj.gridItemOrd.getPanel();
				p.find("#addIcon").linkbutton("enable",false);
				p.find("#editIcon").linkbutton("enable",false);
				p.find("#delIcon").linkbutton("enable",false);
				obj.selRowDataView();
				$("#editIcon").linkbutton("enable");
				$("#delIcon").linkbutton("enable");
				$("#addIcon").linkbutton("disable");
				// 根据选择行的index，判断是不是要显示“上移”和“下移”是否显示
				var gridPageSize = $('#gridItemOrd').datagrid('options').pageSize-1;
				if (obj.gridItmCnt!=1){
					if (rindex==0) {
						// 选择行为第一行
						$("#moveDown").linkbutton("enable");
					}else if((rindex==gridPageSize) || (rindex==obj.gridItmCnt-1)){
						// 选择行为当前页最后一行或者是所记载数据的最后一项
						$("#moveUp").linkbutton("enable");
					}else{
						$("#moveUp").linkbutton("enable");
						$("#moveDown").linkbutton("enable");
					}
				}
				obj.curFormOrdID=rowData.xID;
				obj.isCNMedItem=$cm({
					ClassName:"DHCMA.CPW.IO.FromDoc",
					MethodName:"IsCPWCNMedItem",
					aArcimRowid:rowData.OrdMastID,
					aHospID:CurrHosp
				},false);
			}
		},
		onUnselect:function(rindex,rowData){
			obj.isCNMedItem=0;
			obj.curFormOrdID="";
		},
		onUncheck:function(rindex,rowData){
			if (obj.cfgModifyVal != "Y"){
				$("#editIcon").linkbutton("disable");
				$("#delIcon").linkbutton("disable");
				$("#addIcon").linkbutton("enable");
				$("#moveUp").linkbutton("disable");
				$("#moveDown").linkbutton("disable");
			}
		},
		onClickRow: function(rowIndex,rowData){//增加点击选中，再次点击取消选中 by wjf
			if (obj.cfgModifyVal == "Y") return;		// 发布后禁止修改关联医嘱则点击不进入编辑状态
		
			if(obj.IsCheckIndex == rowIndex){//再次点击该行 
				$("#gridItemOrd").datagrid("unselectRow", rowIndex)
				.datagrid('endEdit', rowIndex);	
				obj.IsCheckIndex = -1;
				$("#cboOrdTypeDr").combobox("setValue","");
				$("#itemOrdID").val("");
				$("#txtOrdMastIDH").val("");
				$("#txtOrdMastID").val("").validatebox("validate");
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
				$("#txtOrdPosShow").val("");
				$("#txtOrdUseDays").val("");
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
			
		},
		onLoadSuccess:function(){
			// 获取当前页的行数
			obj.gridItmCnt = $("#gridItemOrd").datagrid("getRows").length;
		}
	});
	 	
	$("#txtOrdMastID").lookup({
		width:300,
		panelWidth:780,
		panelHeight:400,
		url:$URL,	//+"?ClassName=DHCMA.CPW.BTS.LinkArcimSrv&QueryName=QryArcimByAlias&ResultSetType=array",
		mode:'remote',
		method:"Get",
		idField:'ArcimID',
		textField:'ArcimDesc',
		columns:[[  
			{field:'ArcimCode',title:'代码',width:100},  
			{field:'ArcimDesc',title:'描述',width:400},
			{field:'OrdPrice',title:'单价',width:150},  
			{field:'ArcimID',title:'ID',width:70}  
		]],
		pagination:true,
		isCombo:true,
		minQueryLen:2,
		delay:'500',
		required:true,
		missingMessage:"该输入项为必输项",
		deltaX:-10,
		queryOnSameQueryString:true,
		queryParams:{ClassName:'DHCMA.CPW.BTS.LinkArcimSrv',QueryName:'QryArcimByAlias',aHospID:CurrHosp},
		onSelect:function(index,rowData){
			obj.Arcim = rowData
			//console.log("index="+index+",rowData=",rowData);
			//检查是否是草药类医嘱
			obj.isCNMedItem=$cm({
				ClassName:"DHCMA.CPW.IO.FromDoc",
				MethodName:"IsCPWCNMedItem",
				aArcimRowid:rowData.ArcimID,
				aHospID:CurrHosp
			},false);
			
			//长期医嘱类型医嘱项设置天数初始值取当前阶段天数
			var selGridRow = $('#gridItemOrd').datagrid('getSelected');
			if (obj.isLongOrdType==1 && (selGridRow == null || selGridRow == undefined)){
				if (obj.Arcim!="" && obj.Arcim.ArcimID.indexOf("||")!=-1){		//医嘱项
					$("#txtOrdUseDays").val(obj.CurrEpDays);
				}else{
					$("#txtOrdUseDays").val("");	
				}	
			}
			
			
			//检查医嘱是否有检查部位选择  dsp
			var OrdBodyStr = $cm({
				ClassName:"web.DHCAPPExaReportQuery",
				MethodName:"jsonGetPartTreeByArc",
				itmmastid:rowData.ArcimID,
				PyCode:"",
				TraID:"",
				HospID:CurrHosp.split("!!")[0],
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
						width:1200,
						height:500,
						CallBackFunc:function(ret){
							if((ret!="")&&(ret!=undefined)){
								var arrPos=ret.split("^")
								var strPos=arrPos[0]+"||"+arrPos[1]+"||"+arrPos[2];
								$("#txtOrdPos").val(strPos);
								$("#txtOrdPosShow").val(arrPos[0]);
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
	
	//医嘱套医嘱列表
  	obj.gridARCOSOrder = $HUI.datagrid("#gridARCOSOrder",{
		fit: true,
		pagination: false, //如果为true, 则在DataGrid控件底部显示分页工具栏
		rownumbers: true, //如果为true, 则显示一个行号列
		singleSelect: false,
		remoteSort:false,
		sortName:"SeqNo",
		sortOrder:"asc",
		autoRowHeight: false, //定义是否设置基于该行内容的行高度。设置为 false，则可以提高加载性能
		loadMsg:'数据加载中...',   
		columns:[[
			{field:'ARCIMDesc',title:'医嘱名称',width:'300'},
			{field:'DoseQty',title:'单次剂量',width:'80'},
			{field:'DoseUOMDesc',title:'剂量单位',width:'80'},
			{field:'FreqDesc',title:'频次',width:'80'},
			{field:'InstrDesc',title:'用法',width:'80'},
			{field:'DurDesc',title:'疗程',width:'80'},
			{field:'SeqNo',title:'序号',width:'80'}	
		]],
		onBeforeLoad: function (param) {
	        var firstLoad = $(this).attr("firstLoad");
	        if (firstLoad == "false" || typeof (firstLoad) == "undefined")
	        {
	            $(this).attr("firstLoad","true");
	            return false;
	        }
	        return true;
		},
		rowStyler: function(index,row){
			var SeqNo=row.SeqNo;
			if (SeqNo=="") return;
			if (SeqNo.indexOf(".")>-1) return 'background-color:#cdf1cd;';
			else return 'background-color:#94e494;';						
		}
	});
	
	ShowARCOSDetail = function(ARCOSRowid){
		$('#gridARCOSOrder').datagrid('loadData',{rows:[],total:0});
		$cm({
			ClassName:"DHCMA.CPW.BTS.PathFormEpSrv",
			QueryName:"QryOrderByARCOS",
			ARCOSRowid:ARCOSRowid,
			aHospID:CurrHosp,
			page:1,
			rows:99999
		},function(rs){
			$('#gridARCOSOrder').datagrid('loadData',rs);
			$('#ARCOSCPWDialog').dialog({title:"当前医嘱明细"});   
			$HUI.dialog('#ARCOSCPWDialog').open();
		})	
	}
	
	
	InitHISUIWinEvent(obj);
	obj.LoadEvents(arguments);
	return obj;
}
