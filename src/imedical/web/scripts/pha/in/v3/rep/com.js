/**
 * 模块:     日月年报-公共组件及方法
 * 编写月期: 2022-05-18
 * 编写人:   yangsj
 * 主要包含以下几个部分
  * 		DATA      : 固定数据
  * 		COLUMNS   : 公共表格列
  * 		FORMATTER : 数据样式
  * 		OPERATE   : 公共操作方法
  * 		FUNCTION  : 公共获取数据或者查询方法
  *			INITGRID  : 初始化表格
  *  scripts/pha/in/v3/rep/com.js
 */
 
var REP_COM = {
	
	/* 固定数据在此获取 */
	DATA :{
	
		/* 业务类型及其描述 */
		BusiTypeData : PHA.CM({
	        pClassName: 'PHA.IN.REP.Api',
	        pMethodName: 'GetBusiType'
	    }, false),
	    
	    /* 损益业务类型及其描述 */
	    RetATypeData : PHA.CM({
	        pClassName: 'PHA.IN.REP.Api',
	        pMethodName: 'GetRetAType'
	    }, false),
	    
	    DataType : ["BEGIN", "BUSI", "RETA", "END", "DIF"],
 	
		ColType : ["Qty", "RpAmt", "SpAmt"],
		
		ColTypeDesc : ["数量", "进价金额", "售价金额"],
		
		TabalSuffix : ["", "RpAmt", "SpAmt"]

	},
 	
 	/* 公共表格列 */
 	COLUMNS : {
	 	/* 药品信息固定列 */
	 	InciFrozen : [
	        [
	        	{ field: 'repiId', 		title: 'repiId', 	align: 'center', 	width: 80 	,hidden:true},
	            { field: 'inciCode', 	title: '代码', 		align: 'left', 		width: 120	},
	            { field: 'inciDesc', 	title: '名称', 		align: 'left', 		width: 250	},
	            { field: 'scgDesc', 	title: '类组', 		align: 'center', 	width: 80	},
	            { field: 'bUomDesc', 	title: '基本单位', 	align: 'center', 	width: 80	}
	        ]
	    ],
	    
	    /* 类组信息固定列 */
	    ScgFrozen :[
	        [
	        	{ field: 'repiId', 		title: 'repiId', 	align: 'center', width: 80 ,hidden:true},
	            { field: 'scgDesc', 	title: '类组', 		align: 'center', width: 80 },
	        ],
	    ],
	    
	    /* 数据类型列 */
	    FirstRow : function(cols, rows, busiNum, retANum){
		    return [
				{  	title:'期初数据',	 align:'center',	halign:'center',    colspan:cols,				rowspan: rows },  // 3, 2
				{  	title:'业务数据',	 align:'center',	halign:'center',	colspan:busiNum},
				{  	title:'损益数据',	 align:'center',	halign:'center',	colspan:retANum},
				{ 	title:'截止数据',	 align:'center',	halign:'center',	colspan:cols,				rowspan: rows},
				{ 	title:'差异数据',	 align:'center',	halign:'center',	colspan:cols,				rowspan: rows}
			]
	    }
 	},
 	
	/* 数据样式 */
	FORMATTER :{
	
		AllStateStyler :function(value, row, index){
	     	switch (value) {
				case 'SAVE':
					colorStyle = 'background:#a4c703;color:white;';  
					break;
				case 'USE':
					colorStyle = 'background:#f1c516;color:white;';
					break;
				case 'CANCEL':
					colorStyle = 'background:#ee4f38;color:white;';
					break;
				case 'DIF':
					colorStyle = 'background:#d773b0;color:white;';
					break; 
				case 'AUDIT':
					colorStyle = 'background:#a4c703;color:white;';
					break;    
				default:
					colorStyle = 'background:white;color:black;';
					break;
		    }
	     	return colorStyle;
		},
		
		AllStateFormatter : function(value, row, index){
			if (value == 'SAVE') {
		        return $g("生成");
		    } else if (value == 'USE') {
			    if (row.repType == 'D') return $g("计入月报");
			    else if (row.repType == 'M') return $g("计入年报");
		        else return value;
		    }else  if (value == 'CANCEL') {
		        return $g("作废");
		    }else  if (value == 'AUDIT') {
		        return $g("差异确认");
		    }else  if (value == 'DIF') {
		        return $g("差异待确认");
		    }else {
	        	return "";
	    	}
		},
		
		NumFormatter : function(value, row, index){
			if (!value) {
		        return 0;
		    } else {
		        return value;
		    }
		},
		
		DifNumStateStyler : function(value, row, index){
			var difFlag = "N"
			if(parseFloat(value)) difFlag ="Y"
		 	switch (difFlag) {
			 	 case 'Y':
		         	 colorStyle = 'background:#f1c516;color:white;';
		             break;
		         default:
		             colorStyle = 'background:white;color:black;';
		             break;
		     }
		     return colorStyle;
		},
		
		AllStateStyler : function (value, row, index){
		    switch (value) {
		        case 'SAVE':
		            colorStyle = 'background:#a4c703;color:white;';  
		            break;
		        case 'USE':
		            colorStyle = 'background:#f1c516;color:white;';
		            break;
		        case 'CANCEL':
		         	colorStyle = 'background:#ee4f38;color:white;';
		            break;
		        case 'DIF':
		         	colorStyle = 'background:#d773b0;color:white;';
		            break; 
		        case 'AUDIT':
		         	colorStyle = 'background:#a4c703;color:white;';
		            break;    
		        default:
		            colorStyle = 'background:white;color:black;';
		            break;
		    }
		    return colorStyle;
		},
		
		DifStateFormatter : function (value, row, index){
			if (value == 'Y') {
		        return $g("有");
		    } else if (value == 'N') {
		        return "无";
		    }else  if (value == 'AUDIT') {
		        return $g("差异确认");
		    }else {
		        return "";
		    }
		},
		
		DifStateStyler : function(value, row, index){
		 	switch (value) {
				case 'Y':
		    		colorStyle = 'color:#d773b0;';
		    		break;
				case 'N':
		    		colorStyle = 'color:#a4c703;';  
		      		break;
				case 'AUDIT':
					colorStyle = 'color:#a4c703;';
					break;
				default:
					colorStyle = 'color:black;';
					break;
			}
			return colorStyle;
		},
		
		/* 日历字体背景色 */
		DayStatusStyler : function(value, row, index){
			if (value.indexOf("-") >= 0) value = value.split("-")[1]
		    switch (value) {
		        case 'SAVE':
		            colorStyle = 'color:#a4c703;';  
		            break;
		        case 'USE':
		            colorStyle = 'color:#f1c516;';
		            break;
		        case 'CANCEL':
		          	colorStyle = 'color:#ee4f38;';
		            break;
		        case 'DIF':
		         	colorStyle = 'color:#d773b0;';
		            break;
		        default:
		            colorStyle = 'color:black;';
		            break;
		    }
		    return colorStyle;
		},
		
		/* 日历日期显示值 */
		DayFormatter : function(value, row, index){
			if (value.indexOf("-") >= 0) value = value.split("-")[0]
			return value
		}
	},
	
	/* 公共操作方法在此定义 */
	OPERATE : {
		/* 清除表格内容 */
		ClearGrid : function(gridId){
			gridId = REP_COM.FUNCTION.GetNewId(gridId);
			$(gridId).datagrid('loadData', []);
		},
		
		/* 选中某个日期 （单元格）*/
		SelectCell : function(grid, index, fidld){
			grid =  REP_COM.FUNCTION.GetNewId(grid) 
			$(grid).datagrid('editCell', {
				index: index,
				field: fidld
			});
		},
		ClearGridAllDetail: function(){
			$('#gridRep').datagrid('loadData', []);
			$('#gridRepOperate').datagrid('loadData', []);
			$('#gridRepInciAll').datagrid('loadData', []);
			$('#gridRpAmtDetail').datagrid('loadData', []);
			$('#gridSpAmtDetail').datagrid('loadData', []);
			$('#gridScgRpAmtTotal').datagrid('loadData', []);
			$('#gridScgSpAmtTotal').datagrid('loadData', []);
		}
	},
	
	/* 公共获取数据或者查询方法在此定义 */
	FUNCTION : {
		/* 获取报表ID */
		GetRepId : function (){
			var gridSelect = $('#gridRep').datagrid('getSelected') || '';
		    if (gridSelect) return gridSelect.repId;
		    return '';
		},
		
		/* 查询报表操作记录 */
		QueryRepOperate : function(){
			var repId = REP_COM.FUNCTION.GetRepId()
			if(!repId) return;
			$('#gridRepOperate').datagrid('query', {
		        pJson : JSON.stringify({repId:repId})
		    });
		},
	
		/* 查询多页签明细数据
		   input: isSelect = select  标识是切换页签调用的查询
		 */
		
		QueryRepDetail : function(isSelect){
			var isSelect = isSelect || '';
			var repId = REP_COM.FUNCTION.GetRepId()
			if(!repId) return;
			
			var isAutoRefreFlag = 1;
			if (isSelect == 'select'){
				isAutoRefreFlag =0;
				var KwArr = $('#tabKw').keywords('getSelected');
				for(var i = 0; i < KwArr.length; i++){
					if (KwArr[i].id = 'autoRefresh'){
						isAutoRefreFlag = 1;
						break;
					}	
				}
			}
			if (!isAutoRefreFlag) return;
			
			var tabId = $('#tabDetail').tabs('getSelected').panel('options').id;
			var retACheckId = "";
			var inciAliasId = "";
			var statType = "";
			var gridId = "";
			
		    if (tabId == 'allDetail'){  			// 详细明细
			    gridId = '#gridRepInciAll';
			    retACheckId = '#onlyRetA';
			    inciAliasId = "inciAlias";
		    }else if (tabId == 'RpAmt'){  			// 进价明细
				gridId = '#gridRpAmtDetail';
				statType = 'RpAmt'
				retACheckId = '#onlyRetARpAmt'
				inciAliasId = "inciAliasRpAmt";
		    }else if (tabId == 'SpAmt'){  			// 售价明细
				gridId = '#gridSpAmtDetail';
				statType = 'RpAmt'
				retACheckId = '#onlyRetASpAmt'
				inciAliasId = "inciAliasSpAmt";
		    }else if (tabId == 'ScgRpAmt'){  		// 进价类组汇总
				gridId = '#gridScgRpAmtTotal';
				statType = 'RpAmt'
		    }else if (tabId == 'ScgSpAmt'){  		// 售价类组汇总
				gridId = '#gridScgSpAmtTotal';
				statType = 'SpAmt'
		    }
		    var inciAlias = inciAliasId ? $('#' + inciAliasId).combobox('getText') : '';
		    var onlyRetA = $(retACheckId).is(':checked') ? 'Y' : 'N';
		    var pJson = {
		    	repId  : repId,
		    	onlyRetA : onlyRetA,
		    	statType : statType,
		    	inciAlias : inciAlias
			}
			$(gridId).datagrid('loadData', []);
		    $(gridId).datagrid('query', {
		        pJson : JSON.stringify(pJson)
		    });
		},
		
		/* 获取新ID，加上#前缀 */
		GetNewId : function (id){
			if (!id) return "";
			id = '#' + id;
			return id;
		},
		
		/* 差异确认 */
		AuditDif : function (){
			var repId = REP_COM.FUNCTION.GetRepId()
			if (repId == '') {
				PHA.Msg('alert','请选择一条报表记录！')
				return false;
			}
			var	pJson = {
				repId	: repId,
				userId 	: session['LOGON.USERID']
			}
			var retData = PHA.CM(
		        {
		            pClassName : 'PHA.IN.REP.Api',  
		            pMethodName: 'AuditDif',
		            pJson	   : JSON.stringify(pJson),
		        },false) 
	        if (PHA.Ret(retData)) return true;
		    else return false; 
		},
		
		/* 作废 */
		Cancel : function (){
			var repId = REP_COM.FUNCTION.GetRepId();
			if (repId == '') {
				PHA.Msg('alert','请选择一条报表记录！')
				return false;
			}
			var	pJson = {
				repId	: repId,
				userId 	: session['LOGON.USERID']
			}
			var retData = PHA.CM(
		        {
		            pClassName : 'PHA.IN.REP.Api',  
		            pMethodName: 'Cancel',
		            pJson	   : JSON.stringify(pJson),
		        },false) 
	        if (PHA.Ret(retData)) return true;
		    else return false; 
		},
		AmtDesc : function(amtType){
			var amtDesc = ""
			if (amtType == "RpAmt") amtDesc = "进价金额"
			else if (amtType == "SpAmt") amtDesc = "售价金额"
			return amtDesc;
		}
	},
	
	/* 初始化表格 */
	INITGRID : {
			/* 初始化公共表格  */
			InitComGrid: function(){
				
				REP_COM.INITGRID.RepOperate('gridRepOperate');
				REP_COM.INITGRID.RepInci('gridRepInciAll', 'repInciAllBar');
				REP_COM.INITGRID.AmtDetail('gridRpAmtDetail', 'RpAmt', 'gridRpAmtDetailBar');
				REP_COM.INITGRID.AmtDetail('gridSpAmtDetail', 'SpAmt', 'gridSpAmtDetailBar');
				REP_COM.INITGRID.ScgAmtTotal('gridScgRpAmtTotal', 'RpAmt');
				REP_COM.INITGRID.ScgAmtTotal('gridScgSpAmtTotal', 'SpAmt');
				
				/* 初始化页签关键字 */
				$('#tabKw').keywords({
			        onClick:function(v){
				        REP_COM.FUNCTION.QueryRepDetail('select');
				    },
				    singleSelect: false,
			        items:[
			        	{text: '切换页签自动刷新',	id: "autoRefresh",	selected: false}
			        ]
				});	
				
				/* 绑定切换页签方法 */
				$('#tabDetail').tabs({    
			        onSelect:function(title,index){    
			        	REP_COM.FUNCTION.QueryRepDetail('select');
			        }    
			 	});
			 	
			 	/* 初始化条件 */
				for (i=0;i<REP_COM.DATA.TabalSuffix.length;i++){
				 	PHA_UX.ComboBox.INCItm('inciAlias' + REP_COM.DATA.TabalSuffix[i], {
						hasDownArrow: false,
						width:200,
						placeholder: '药品别名...',
					});	
				}
				
				/* 绑定筛选按钮事件 */
				PHA.BindBtnEvent('#gridRepBar');
				PHA.BindBtnEvent('#gridRpAmtDetailBar');
				PHA.BindBtnEvent('#gridSpAmtDetailBar');
			},
		
			/* 全部明细 */
			RepInci : function(gridId, barId){
			var secondColums = [];
			var thirdColums  = [];
			var secondCount  = 0;
			var thirdCount   = 0;
			var busiTypeData = REP_COM.DATA.BusiTypeData;
			var retATypeData = REP_COM.DATA.RetATypeData;
			var busiLen = busiTypeData.length;
			var retALen = retATypeData.length;
			var busiNum = busiLen * 3;
			var retANum = retALen * 3;
			var dataType = REP_COM.DATA.DataType;
			var colType = REP_COM.DATA.ColType;
			var colTypeDesc = REP_COM.DATA.ColTypeDesc;
			var lenArr = [1, busiLen, retALen, 1, 1]
			for (i=0;i<5;i++){
				leni = lenArr[i]
				if(i==0 || i==3 || i==4 ) leni = 1   	//如果是期初和期末，则第二行为空，第三行只有三列
				for (j=0;j<leni;j++){
					if (i == 1){  						//业务数据
						typeDataObj = busiTypeData[j]
					}
					else if(i == 2){  					//损益数据
						typeDataObj = retATypeData[j]
					}
					if(i==1||i==2){
						var field = dataType[i] + "_" + typeDataObj.code
						var title = typeDataObj.desc
						var col ={	title: title, 	align: 'right', colspan:3 }
						secondColums[secondCount] = col
						secondCount++
					}
					for (h=0;h<3;h++){
						if(i==1 || i==2){
							var field = dataType[i] + "_" + typeDataObj.code + "_" + colType[h]
							var title = colTypeDesc[h]
						}
						else{
							var field = dataType[i] + colType[h]
							var title = colTypeDesc[h]
						}
						if(i==4){
							var col ={field: field, 	title: title, 	align: 'right', width: 100 ,formatter:REP_COM.FORMATTER.NumFormatter,	styler:REP_COM.FORMATTER.DifNumStateStyler}
						}
						else{
							var col ={field: field, 	title: title, 	align: 'right', width: 100 ,formatter:REP_COM.FORMATTER.NumFormatter}
						}
						thirdColums[thirdCount] = col
						thirdCount++
					}
				} 
			}
			var firstColums = REP_COM.COLUMNS.FirstRow(3, 2, busiNum, retANum);
			var columns = [
		   		firstColums,
		   		secondColums,
		   		thirdColums
		    ];
		    var dataGridOption = {
		        url: PHA.$URL,
		        queryParams: {
		            pClassName : 'PHA.IN.REP.Api',
		            pMethodName: 'QueryRepInciAll',
		            pPlug	   : "datagrid",
		            pJson      : "{}",
		        },
		        bodyCls:'table-splitline',
		        gridSave: false,
		        //view:scrollview,
		        pageSize:50,
		        pagination: false,
		        gridSave:false,
		        columns: columns,
		        frozenColumns: REP_COM.COLUMNS.InciFrozen,
		        rownumbers: true,
		        fixRowNumber: true,
		        toolbar: REP_COM.FUNCTION.GetNewId(barId),
		        exportXls: true,
		        onClickRow: function (rowIndex, rowData) {},
		        onDblClickRow: function (rowIndex, rowData) {},
		    };
			if (typeof barId === 'undefined') {
				delete dataGridOption.toolbar;
			}
		    PHA.Grid(gridId, dataGridOption);
		},
		
		/* 操作记录列表 */
		RepOperate : function(gridId) {
			var columns = [
		        [
		        	{ field: 'repoId', 		title: 'repoId', 	align: 'center', width: 80  ,hidden:true},
		        	{ field: 'status', 		title: '操作状态', 	align: 'center', width: 150  ,styler:REP_COM.FORMATTER.AllStateStyler,formatter:REP_COM.FORMATTER.AllStateFormatter},
		        	{ field: 'userName', 	title: '操作人员', 	align: 'left',   width: 80  },
		        	{ field: 'date', 		title: '操作日期', 	align: 'center', width: 120 },
		            { field: 'time', 		title: '操作时间', 	align: 'center', width: 120 },
		        ],
		    ];
		    var dataGridOption = {
		        url: PHA.$URL,
		        gridSave: false,
		        queryParams: {
		            pClassName : 'PHA.IN.REP.Api',
		            pMethodName: 'QueryRepOperate',
		            pPlug	   : "datagrid",
		            pJson      : "{}",
		        },
		        gridSave:false,
		        columns: columns,
		        exportXls: true,
		        pagination: false,
		    };
		    PHA.Grid(gridId, dataGridOption);
		},
		
		/* 进售价明细列表 */
		AmtDetail: function (gridId, amtType, barId){
		 	var busiTypeData = REP_COM.DATA.BusiTypeData;
			var retATypeData = REP_COM.DATA.RetATypeData;
		
			var secondColums = []
			var secondCount  = 0
			
			var busiLen = busiTypeData.length
			var retALen = retATypeData.length
			
			var amtDesc = REP_COM.FUNCTION.AmtDesc(amtType)
			
			var lenArr = [1,busiLen,retALen,1,1]
			var firstColums = [
				{  	title:'期初' + amtDesc,	 field:'BEGIN' + amtType,  	align:'right',		colspan:1,			rowspan: 2, 	width: 100 ,formatter:REP_COM.FORMATTER.NumFormatter}, 
				{  	title:'业务数据' + amtDesc,	 						align:'center',		colspan:busiLen,	halign:'center'	},
				{  	title:'损益数据' + amtDesc,	 						align:'center',		colspan:retALen,	halign:'center'	},
				{ 	title:'截止' + amtDesc,	 field:'END' + amtType,		align:'right',		colspan:1,			rowspan: 2,		width: 100 ,formatter:REP_COM.FORMATTER.NumFormatter},
				{ 	title:'差异' + amtDesc,	 field:'DIF' + amtType,		align:'right',		colspan:1,			rowspan: 2, 	width: 100 ,formatter:REP_COM.FORMATTER.NumFormatter,	styler:REP_COM.FORMATTER.DifNumStateStyler}
			]
			
			var dataType = REP_COM.DATA.DataType
			for (i=0;i<5;i++){
				lenNew = lenArr[i]
				if(lenNew == 1) continue;
				for (j=0;j<lenNew;j++){
					if (i == 1){  //业务数据
						typeDataJson = busiTypeData[j]
					}
					else if(i == 2){  //损益数据
						typeDataJson = retATypeData[j]
					}
					var field = dataType[i] + "_" + typeDataJson.code + "_" + amtType
					var title = typeDataJson.desc
					
					var col ={	title: title, field:field,	align: 'center', width: 100 ,formatter:REP_COM.FORMATTER.NumFormatter}
					secondColums[secondCount] = col
					secondCount++
				} 
			}
			
			var columns = [
		   		firstColums,
		   		secondColums
		    ];
		    var dataGridOption = {
		        url: PHA.$URL,
		        queryParams: {
		            pClassName : 'PHA.IN.REP.Api',
		            pMethodName: 'QueryRepInciAll',
		            pPlug	   : "datagrid",
		            pJson      : "{}",
		        },
		        bodyCls:'table-splitline',
		        gridSave: false,
		        //view:scrollview,
		        //pageSize:50,
		        pagination: false,
		        gridSave:false,
		        columns: columns,
		        frozenColumns: REP_COM.COLUMNS.InciFrozen,
		        rownumbers: true,
		        fixRowNumber: true,
		        toolbar: REP_COM.FUNCTION.GetNewId(barId),
		        exportXls: true,
		    };
		    PHA.Grid(gridId, dataGridOption);
		},

		/* 类组金额汇总 */
		ScgAmtTotal : function(gridId, amtType, barId){
		 	var busiTypeData = REP_COM.DATA.BusiTypeData;
			var retATypeData = REP_COM.DATA.RetATypeData;
		    
			var secondColums = []
			var secondCount  = 0
			
			busiLen = busiTypeData.length
			retALen = retATypeData.length
			
			var amtDesc = REP_COM.FUNCTION.AmtDesc(amtType)
			
			var lenArr = [1, busiLen, retALen, 1, 1]
			var firstColums = [
				{  	title:'期初' + amtDesc,	 field:'BEGIN' + amtType,  	align:'right',		colspan:1,			rowspan: 2 , 	width: 100 ,formatter:REP_COM.FORMATTER.NumFormatter	}, 
				{  	title:'业务数据' + amtDesc,	 						align:'center',		colspan:busiLen,	halign:'center'	},
				{  	title:'损益数据' + amtDesc,	 						align:'center',		colspan:retALen,	halign:'center'	},
				{ 	title:'截止' + amtDesc,	 field:'END' + amtType,		align:'right',		colspan:1,			rowspan: 2 , 	width: 100 ,formatter:REP_COM.FORMATTER.NumFormatter	},
				{ 	title:'差异' + amtDesc,	 field:'DIF' + amtType,		align:'right',		colspan:1,			rowspan: 2 , 	width: 100 ,formatter:REP_COM.FORMATTER.NumFormatter	,	styler:REP_COM.FORMATTER.DifNumStateStyler}
			]
			
			var dataType = REP_COM.DATA.DataType
			for (i=0;i<5;i++){
				lenNew = lenArr[i]
				if(lenNew==1) continue;
				for (j=0;j<lenNew;j++){
					if (i == 1){  //业务数据
						typeDataJson = busiTypeData[j]
					}
					else if(i == 2){  //损益数据
						typeDataJson = retATypeData[j]
					}
					var field = dataType[i] + "_" + typeDataJson.code + "_" + amtType
					var title = typeDataJson.desc
					
					var col ={	title: title, field:field,	align: 'center', width: 100 ,formatter:REP_COM.FORMATTER.NumFormatter}
					secondColums[secondCount] = col
					secondCount++
				} 
			}
			var columns = [
		   		firstColums,
		   		secondColums
		    ];
		    var dataGridOption = {
			   
		        url: PHA.$URL,
		        queryParams: {
		            pClassName : 'PHA.IN.REP.Api',
		            pMethodName: 'QueryScgAmt',
		            pPlug	   : "datagrid",
		            pJson      : "{}",
		        },
		        bodyCls:'table-splitline',
		        gridSave: false,
		        //view:scrollview,
		        pageSize:50,
		        pagination: false,
		        gridSave:false,
		        columns: columns,
		        frozenColumns: REP_COM.COLUMNS.ScgFrozen,
		        rownumbers: true,
		        fixRowNumber: true,
		        toolbar: REP_COM.FUNCTION.GetNewId(barId),
		        exportXls: true,
		        onClickRow: function (rowIndex, rowData) {},
		        onDblClickRow: function (rowIndex, rowData) {},
		    };
			if (typeof barId === 'undefined') {
				delete dataGridOption.toolbar;
			}
		    PHA.Grid(gridId, dataGridOption);
		}
	}
}


 