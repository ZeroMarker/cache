//页面Gui
var obj = new Object();
function InitHISUIWin﻿(){
	$.parser.parse(); // 解析整个页面
	
	//院区	
	var SessionStr=session['LOGON.USERID']+"^"+session['LOGON.GROUPID']+"^"+session['LOGON.CTLOCID']+"^"+session['LOGON.HOSPID']
	obj.cboHosp = Common_ComboToSSHosp3("cboHosp","","","DHCMA_CPW_BT.PathMast",SessionStr,"");
	
	//路径类型
	obj.cboPathType = $HUI.combobox('#cboPathType', {
		url:$URL,
		onBeforeLoad:function(param){
			param.ClassName="DHCMA.CPW.BTS.PathTypeSrv",
			param.QueryName="QryPathType",
			param.aHospID=$("#cboHosp").combobox('getValue'),
			param.ResultSetType='array'	
		},
		/*onShowPanel: function(){
			$(this).combobox('reload');	
		},*/
		editable: true,
		valueField: 'BTID',
		textField: 'BTDesc',
		defaultFilter:4
	});
	
	
	//已关联医嘱
	$("#txtSelArcims").lookup({
		width:340,
		panelWidth:500,
		panelHeight:300,
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
		queryOnSameQueryString:true,
		queryParams:{ClassName:'DHCMA.CPW.BTS.LinkArcimSrv',QueryName:'QryArcimByAlias',aFlag:"1",aHospID:$("#cboHosp").combobox("getValue")}
	});
	
	//关联医嘱列表
	obj.gridRelateArcim = $HUI.datagrid("#gridRelateArcim",{
		fit: true,
		title:"查询需替换医嘱",
		border:false,
		headerCls:'panel-header-gray',
		showGroup: true,
		groupField:'xPathMastDesc',
		checkOnSelect:false,
		view: groupview,
		groupFormatter:function(value, rows){
			if(rows==undefined) return false;
			return "路径："+value + ' , 共( ' + rows.length + ' )项';
		},
		scrollbarSize: 0,
		checkOnSelect: true,
		rownumbers: true, //如果为true, 则显示一个行号列
		singleSelect: false,
		autoRowHeight: false, //定义是否设置基于该行内容的行高度。设置为 false，则可以提高加载性能
		loadMsg:'数据加载中...',
		pagination: true, //如果为true, 则在DataGrid控件底部显示分页工具栏
		pageSize: 20,
		pageList : [20,50,100,200],
		/*
		url:$URL,
		queryParams:{
		    ClassName:"DHCMA.CPW.BTS.BatHandleOrd",
			QueryName:"QryRelPathOrds",
			aPathTypeID:"",
			aArcimID:"",
			aHospID:""
	    },*/
		columns:[[
			{field:'checkOrd',checkbox:true,align:'center',width:'',auto:false},
			{field:'EpDesc',title:'阶段',width:'150'},
			{field:'OrdMastDesc',title:'医嘱名',width:'300'
				,formatter: function(value,row,index){
					var chkPosDesc=row['OrdChkPosID'].split("||")[0];
					return value+chkPosDesc;
				}
			},
			{field:'OrdLnkOrdDr',title:'关联号',width:'50'},
			{field:'OrdDoseQty',title:'单次剂量',width:'70'},
			{field:'OrdUOMDesc',title:'单位',width:'70'},
			{field:'OrdFreqDesc',title:'频次',width:'70'},
			{field:'OrdInstrucDesc',title:'用法',width:'70'},
			{field:'OrdDuratDesc',title:'疗程',width:'70'},
			{field:'OrdQty',title:'数量',width:'60'},
			{field:'OrdIsDefault',title:'首选医嘱',width:'70'},
			{field:'OrdIsFluInfu',title:'主医嘱',width:'70'},
			{field:'OrdTypeDesc',title:'分类标记',width:'70'},
			{field:'OrdPriorityDesc',title:'医嘱类型',width:'70'},
			{field:'OrdNote',title:'备注',width:'70'},
			{field:'ItemDesc',title:'项目',width:'150'},
			{field:'ActUserName',title:'更新人',width:'70'},
		]]
	})
	
	//医嘱分类
	obj.cboOrdTypeDr = $HUI.combobox("#cboOrdTypeDr",{
		url:$URL+"?ClassName=DHCMA.Util.BTS.DictionarySrv&QueryName=QryDictByType&aTypeCode=CPWFormOrdType&ResultSetType=array",
		valueField:'BTID',
		textField:'BTDesc',
		required:true,
		onLoadSuccess:function(data){
            if (data.length > 0) {          
                $(this).combobox('select',data[0].BTID);		 //如果有数据的话默认选中第一条数据
            }
        }
	});
	
	//医嘱类型
	obj.cboOrdPrior = $HUI.combobox("#cboOrdPrior",{
		url:$URL+"?ClassName=DHCMA.CPW.BTS.LinkArcimSrv&QueryName=QryOECPriority&ResultSetType=array",
		valueField:'OECPRID',
		textField:'OECPRDesc',
		required:true
	});	
	
	//替换医嘱
	$("#txtOrdMastID").lookup({
		width:343,
		panelWidth:500,
		panelHeight:300,
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
		required:true,
		missingMessage:"该输入项为必输项",
		deltaX:-10,
		queryOnSameQueryString:false,
		queryParams:{ClassName:'DHCMA.CPW.BTS.LinkArcimSrv',QueryName:'QryArcimByAlias',aHospID:$("#cboHosp").combobox("getValue")},
		onSelect:function(index,rowData){
			obj.Arcim = rowData
			$("#txtOrdPos").val('');
			$("#txtOrdPosShow").val('');
			//console.log("index="+index+",rowData=",rowData);
			//检查医嘱是否有检查部位选择  dsp
			var OrdBodyStr = $cm({
				ClassName:"web.DHCAPPExaReportQuery",
				MethodName:"jsonGetPartTreeByArc",
				itmmastid:rowData.ArcimID,
				PyCode:"",
				TraID:"",
				HospID:$("#cboHosp").combobox("getValue").split("!!")[0],
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
						width:800,
						height:500,
						CallBackFunc:function(ret){
							if((ret!="")&&(ret!=undefined)){
								var arrPos=ret.split("^")
								var strPos=arrPos[0]+"||"+arrPos[1]+"||"+arrPos[2];
								$("#txtOrdPos").val(strPos);
								$("#txtOrdPosShow").val(arrPos[0]);
							}
						}
					})
			}
			obj.OrdMastSelect(rowData);
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
	})
	
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
			if ($("#txtOrdMastID").val() == '') {
				$.messager.popover({msg: '请先选择替换医嘱',type:'info',timeout: 2000,showType: 'show'});
				$("#cboOrdInstruc").lookup('hidePanel');
				return false;
			}
		}
	});
	
	//疗程
	$("#cboOrdDurat").lookup({
		panelWidth:140,
		url:$URL,	//+"?ClassName=DHCMA.CPW.BTS.LinkArcimSrv&QueryName=QryPHCDuration&ResultSetType=array",
		mode:'remote',
		method:"Get",
		isCombo:true,
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
	
	
	InitHISUIWinEvent(obj);
	obj.LoadEvents(arguments);
	return obj;	
}