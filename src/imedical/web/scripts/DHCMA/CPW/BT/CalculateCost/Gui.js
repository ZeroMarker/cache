//页面Gui
function InitCalcCostWin(){
	var obj = new Object();
	obj.BudgetCostID="";
	obj.RecRowID="";
	obj.Arcim="";
	obj.SelectEpDays="";
	obj.isCNMedItem="";
	
	//先获取测算记录父ID
	obj.BudgetCostID= $.cm({
		ClassName:"DHCMA.CPW.BTS.BudgetCostSrv",
		MethodName:"GetBCIDByFormID",
		aFormID:PathFormID,
		aUserID:session['DHCMA.USERID']
	},false);
	
	//医嘱明细列表
	obj.gridFeeDetail = $HUI.datagrid("#gridFeeDetail",{
		fit: true,
		border:false,
		headerCls:'panel-header-gray',
		showGroup: true,
		groupField:'FormEpDesc',
		view: groupview,
		groupFormatter:function(value, rows){
			if(rows==undefined) return false;
			return "阶段："+value + ' , 共( ' + rows.length + ' )项';
		},  
		scrollbarSize: 0,
		checkOnSelect: false,
		rownumbers: true, //如果为true, 则显示一个行号列
		singleSelect: true,
		autoRowHeight: false, //定义是否设置基于该行内容的行高度。设置为 false，则可以提高加载性能
		loadMsg:'正在加载中...',
		pagination: false, //如果为true, 则在DataGrid控件底部显示分页工具栏
		//pageSize: 50,
		//pageList : [50,100,200],
		url:$URL,
		queryParams:{
			ClassName:"DHCMA.CPW.BTS.BudgetOrdRecSrv",
			QueryName:"QryBORecCost",
			aFormID:PathFormID,
			aHospID:CurrHosp,
			page:1,
			rows:99999
		},
		columns:[[
			//{field:'CheckRec',checkbox:'true',align:'center',width:'',auto:false},
			{field:'BORecID',title:'ID',width:'80',hidden:'true'},
			{field:'OrdPriorityDesc',title:'医嘱类型',width:'80'},
			{field:'OrdTypeDesc',title:'分类标记',width:'100'},
			{field:'OrdMastDesc',title:'医嘱名称',width:'350'},
			//{field:'OrdLnkOrdDr',title:'关联号',width:'50'},
			{field:'OrdDoseQty',title:'单次剂量',width:'80'},
			{field:'OrdUOMDesc',title:'剂量单位',width:'80'},
			{field:'BaseUomPrice',title:'单价',width:'150'},
			{field:'OrdFreqDesc',title:'频次',width:'80'},
			//{field:'OrdInstrucDesc',title:'用法',width:'70'},
			//{field:'OrdDuratDesc',title:'疗程',width:'70'},
			{field:'OrdUseDays',title:'天数',width:'80'},
			{field:'OrdQty',title:'数量',width:'80'},
			{field:'OrdQtyUomDesc',title:'数量单位',width:'80'},
			{field:'BORecCost',title:'费用',width:'100'},
			{field:'Resume',title:'备注',width:'150'}
		]],
		onSelect:function(rindex,rowData){
			if (rindex>-1) {
				obj.gridFeeDetail_onSelect();
			}
		},
		onLoadSuccess:function(data){
			$("#btnAdd").linkbutton("enable");
			$("#btnAllDel").linkbutton("enable");
			$("#btnEdit").linkbutton("disable");
			$("#btnDelete").linkbutton("disable");
		}
	})
		
	//阶段1
	obj.cboFormEp = $HUI.combobox('#cboFormEp', {
		url:$URL,
		editable: true,
		required:true,
		valueField: 'ID',
		textField: 'EpDesc',
		defaultFilter:4,
		onBeforeLoad:function(param){
			param.ClassName="DHCMA.CPW.BTS.PathFormEpSrv",
			param.QueryName="QryPathFormEp",
			param.aPathFormDr=PathFormID,
			param.ResultSetType='array'	
		} ,
		onSelect:function(rec){
			obj.SelectEpDays=rec.EpDays;
			$('#cboOrdItem').combobox('clear').combobox('reload');
		} 
	});
	
	//项目1
	obj.cboOrdItem = $HUI.combobox('#cboOrdItem', {
		url:$URL,
		editable: true,
		required:true,
		valueField: 'ID',
		textField: 'ItemDesc',
		defaultFilter:4,
		onBeforeLoad:function(param){
			param.ClassName="DHCMA.CPW.BTS.PathFormEpSrv",
			param.QueryName="QryPathFormEpItem",
			param.aPathFormEpDr=$("#cboFormEp").combobox("getValue"),
			param.aDicCode="B",
			param.ResultSetType='array'	
		}
	});
	
	//关联分类
	obj.cboCategory = $HUI.combobox("#cboCategory",{
		url:$URL+"?ClassName=DHCMA.Util.BTS.DictionarySrv&QueryName=QryDictByType&aTypeCode=CPWFormOrdType&aHospID=" +CurrHosp+ "&ResultSetType=array",
		valueField:'BTID',
		textField:'BTDesc',
		disabled:true,
		required:true,
		onLoadSuccess:function()
		{
			obj.cboSelectByText("cboCategory","01");
		}
	});
	
	//医嘱类型	
	obj.cboPriority = $HUI.combobox("#cboPriority",{
		url:$URL+"?ClassName=DHCMA.CPW.BTS.LinkArcimSrv&QueryName=QryOECPriority&ResultSetType=array",
		valueField:'OECPRID',
		textField:'OECPRDesc',
		required:true,
		onSelect:function(row){
			//长期医嘱类型（含长期医嘱、自备药长期、长期嘱托）数量不可编辑、天数可编辑；否则数量可编辑、天数不可编辑
			if (row.OECPRCode!="S" && row.OECPRCode!="OMST" && row.OECPRCode!="OMCQZT"){		//临时医嘱、出院医嘱
				$("#txtOrdQty").validatebox("setDisabled",false);
				$("#txtOrdUseDays").validatebox("setDisabled",true);
				$("#txtOrdUseDays").val("");
				obj.isLongOrdType=0
			}else{																				//长期医嘱
				$("#txtOrdQty").validatebox("setDisabled",true);
				$("#txtOrdUseDays").validatebox("setDisabled",false);
				var selGridRow = $('#gridFeeDetail').datagrid('getSelected');
				if(selGridRow == null || selGridRow == undefined){
					if (obj.Arcim!="" && obj.Arcim.ArcimID.indexOf("||")!=-1){					//医嘱项
						$("#txtOrdUseDays").val(obj.SelectEpDays);								//为天数设置初始值取当前阶段天数
					}else{																					//医嘱套
						$("#txtOrdUseDays").val("")	
					}	
				}				
				obj.isLongOrdType=1; 
			}
		}
	});
	
	//医嘱项
	$("#txtOrdMast").lookup({
		panelWidth:500,
		url:$URL,	
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
		required:true,
		missingMessage:"该输入项为必输项",
		deltaX:-10,
		queryOnSameQueryString:true,
		queryParams:{ClassName:'DHCMA.CPW.BTS.LinkArcimSrv',QueryName:'QryArcimByAlias',aHospID:CurrHosp,aIsShowOrdSet:"0"},
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
			var selGridRow = $('#gridFeeDetail').datagrid('getSelected');
			if (obj.isLongOrdType==1 && (selGridRow == null || selGridRow == undefined)){
				if (obj.Arcim!="" && obj.Arcim.ArcimID.indexOf("||")!=-1){		//医嘱项
					$("#txtOrdUseDays").val(obj.SelectEpDays);
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
			obj.OrdMast_onSelect(rowData);
		}
	});
	
	//剂量单位（显示剂量基本单位及等效单位）	
	obj.cboOrdUOM = $HUI.combobox("#cboOrdUOM",{
		url:$URL,  //+"?ClassName=DHCMA.CPW.BTS.LinkArcimSrv&QueryName=QryDoseUomByArcim&aArcimID="+rowData.ArcimID+"&ResultSetType=array",
		valueField:'DoseUomID',
		textField:'DoseUomDesc',
		onBeforeLoad:function(param){
			param.ClassName="DHCMA.CPW.BTS.LinkArcimSrv",
			param.QueryName="QryDoseUomByArcim",
			param.aArcimID=$("#txtOrdMast").lookup("getValue"),
			param.aHospID=CurrHosp,
			param.ResultSetType='array'
		}
	});
	
	//频次
	$("#cboOrdFreq").lookup({
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
		]]
	});
	
	//用法
	$("#cboOrdInstruc").lookup({
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
		onBeforeLoad : function(param){
			if ($("#txtOrdMast").val() == '') {
				$.messager.popover({msg: '请先选择医嘱项',type:'info',timeout: 2000,showType: 'show'});
				$("#cboOrdInstruc").lookup('hidePanel');
				return false;
			}
			param.OrdID = obj.Arcim.ArcimID;
			param.Instruc = param.q;
			
			//param = $.extend(param,{OrdID:obj.Arcim.ArcimID,Instruc:param.q});
		}
	});
	
	//疗程
	$("#cboOrdDurat").lookup({
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
		]]
	});
	
	//关联医嘱明细列表
	obj.gridFormOrd = $HUI.datagrid("#gridFormOrd",{
		fit: true,
		border:false,
		headerCls:'panel-header-gray',
 		/* showGroup: true,
		groupField:'ItemDesc',
		view: groupview,
		groupFormatter:function(value, rows){
			if(rows==undefined) return false;
			return "项目："+value + ' , 共( ' + rows.length + ' )项';
		},  */  
		scrollbarSize: 0,
		checkOnSelect: true,
		rownumbers: true, //如果为true, 则显示一个行号列
		singleSelect: false,
		autoRowHeight: true, //定义是否设置基于该行内容的行高度。设置为 false，则可以提高加载性能
		loadMsg:'正在加载中...',
		pagination: false, //如果为true, 则在DataGrid控件底部显示分页工具栏
		columns:[[
			{field:'CheckRec',checkbox:'true',align:'center',width:'',auto:false},
			{field:'OrdPriorityIDDesc',title:'医嘱类型',width:'80'},
			{field:'OrdMastIDDesc',title:'医嘱名',width:'300',
				formatter: function(value,row,index){
					var id=row['xID'].split("||").join("-")
					var chkPosDesc=row['OrdChkPosID'].split("||")[0]
					return "<span id='"+id+"'>"+value+chkPosDesc+"</span>"
					
				}
			},
			{field:'OrdLnkOrdDr',title:'关联号',width:'50'},
			{field:'OrdTypeDrDesc',title:'分类标记',width:'70'},
			{field:'OrdDoseQty',title:'单次剂量',width:'70'},
			{field:'OrdUOMIDDesc',title:'单位',width:'70'},
			{field:'OrdFreqIDDesc',title:'频次',width:'70'},
			{field:'OrdInstrucIDDesc',title:'用法',width:'70'},
			{field:'OrdDuratIDDesc',title:'疗程',width:'70'},
			{field:'OrdQty',title:'数量',width:'60'},
			{field:'OrdQtyUomDesc',title:'数量单位',width:'70'},
			{field:'OrdIsDefault',title:'首选医嘱',width:'70'},
			{field:'OrdIsFluInfu',title:'主医嘱',width:'70'},
			{field:'OrdNote',title:'备注',width:'70'}
		]],
		onCheck:function(index,row){
			var arrDtlRows=$("#gridFeeDetail").datagrid('getData');
			var retFlg=null;
			$.each(arrDtlRows.rows, function(ind, item){
				if (row.xID==item.FormOrderID){
					$.messager.confirm("提示", "测算明细中已存在该记录，是否仍勾选?", function (r) {
						if (!r) $("#gridFormOrd").datagrid("uncheckRow", index);
						return false;
					})
					return false;
				}
			});
			
		},
		onLoadSuccess:function(data){
			if (data.rows.length>0){
				for (var i= 0;i<data.rows.length;i++){
					//console.log(data.rows[i]);
					if(data.rows[i].xID.indexOf("FJ")>-1 || data.rows[i].OrdMastID.indexOf("||")<0){
						//$("input[type='checkbox']")[i+1].disabled = true;	
						//$("input:checkbox[name='CheckRec']")[i+1].disabled = true;
						
						//加载结果删除方剂和医嘱套，只显示医嘱项
						$("#gridFormOrd").datagrid("deleteRow", i);
						i=i-1;	
					}	
				}	
			}	
		}
	})
	
	//阶段2
	obj.cboFormEp2 = $HUI.combobox('#cboFormEp2', {
		url:$URL,
		editable: true,
		required:true,
		valueField: 'ID',
		textField: 'EpDesc',
		defaultFilter:4,
		onBeforeLoad:function(param){
			param.ClassName="DHCMA.CPW.BTS.PathFormEpSrv",
			param.QueryName="QryPathFormEp",
			param.aPathFormDr=PathFormID,
			param.ResultSetType='array'	
		} ,
		onSelect:function(rec){
			obj.SelectEpDays=rec.EpDays;
			$('#cboOrdItem2').combobox('clear').combobox('reload');
		} 
	});
	
	//项目2
	obj.cboOrdItem2 = $HUI.combobox('#cboOrdItem2', {
		url:$URL,
		editable: true,
		required:false,
		valueField: 'ID',
		textField: 'ItemDesc',
		defaultFilter:4,
		onBeforeLoad:function(param){
			param.ClassName="DHCMA.CPW.BTS.PathFormEpSrv",
			param.QueryName="QryPathFormEpItem",
			param.aPathFormEpDr=$("#cboFormEp2").combobox("getValue"),
			param.aDicCode="B",
			param.ResultSetType='array'	
		}
	});
	
	//通过描述赋值
	obj.cboSelectByText = function(idName,selTxt){
		var rstData = $('#'+idName).combobox('getData');
		for(var i=0;i<rstData.length;i++){			
			var objTmp = rstData[i];
			if(objTmp.BTCode == selTxt){
				$('#'+idName).combobox('select',objTmp.BTID);
				break;
			}
		}
	}
	
	

	InitCalcCostEvent(obj);
	obj.LoadEvents(arguments);
	$.parser.parse();  
	return obj;
}
