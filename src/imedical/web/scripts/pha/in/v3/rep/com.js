/**
 * ģ��:     �����걨-�������������
 * ��д����: 2022-05-18
 * ��д��:   yangsj
 * ��Ҫ�������¼�������
  * 		DATA      : �̶�����
  * 		COLUMNS   : ���������
  * 		FORMATTER : ������ʽ
  * 		OPERATE   : ������������
  * 		FUNCTION  : ������ȡ���ݻ��߲�ѯ����
  *			INITGRID  : ��ʼ�����
  *  scripts/pha/in/v3/rep/com.js
 */
 
var REP_COM = {
	
	/* �̶������ڴ˻�ȡ */
	DATA :{
	
		/* ҵ�����ͼ������� */
		BusiTypeData : PHA.CM({
	        pClassName: 'PHA.IN.REP.Api',
	        pMethodName: 'GetBusiType'
	    }, false),
	    
	    /* ����ҵ�����ͼ������� */
	    RetATypeData : PHA.CM({
	        pClassName: 'PHA.IN.REP.Api',
	        pMethodName: 'GetRetAType'
	    }, false),
	    
	    DataType : ["BEGIN", "BUSI", "RETA", "END", "DIF"],
 	
		ColType : ["Qty", "RpAmt", "SpAmt"],
		
		ColTypeDesc : ["����", "���۽��", "�ۼ۽��"],
		
		TabalSuffix : ["", "RpAmt", "SpAmt"]

	},
 	
 	/* ��������� */
 	COLUMNS : {
	 	/* ҩƷ��Ϣ�̶��� */
	 	InciFrozen : [
	        [
	        	{ field: 'repiId', 		title: 'repiId', 	align: 'center', 	width: 80 	,hidden:true},
	            { field: 'inciCode', 	title: '����', 		align: 'left', 		width: 120	},
	            { field: 'inciDesc', 	title: '����', 		align: 'left', 		width: 250	},
	            { field: 'scgDesc', 	title: '����', 		align: 'center', 	width: 80	},
	            { field: 'bUomDesc', 	title: '������λ', 	align: 'center', 	width: 80	}
	        ]
	    ],
	    
	    /* ������Ϣ�̶��� */
	    ScgFrozen :[
	        [
	        	{ field: 'repiId', 		title: 'repiId', 	align: 'center', width: 80 ,hidden:true},
	            { field: 'scgDesc', 	title: '����', 		align: 'center', width: 80 },
	        ],
	    ],
	    
	    /* ���������� */
	    FirstRow : function(cols, rows, busiNum, retANum){
		    return [
				{  	title:'�ڳ�����',	 align:'center',	halign:'center',    colspan:cols,				rowspan: rows },  // 3, 2
				{  	title:'ҵ������',	 align:'center',	halign:'center',	colspan:busiNum},
				{  	title:'��������',	 align:'center',	halign:'center',	colspan:retANum},
				{ 	title:'��ֹ����',	 align:'center',	halign:'center',	colspan:cols,				rowspan: rows},
				{ 	title:'��������',	 align:'center',	halign:'center',	colspan:cols,				rowspan: rows}
			]
	    }
 	},
 	
	/* ������ʽ */
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
		        return $g("����");
		    } else if (value == 'USE') {
			    if (row.repType == 'D') return $g("�����±�");
			    else if (row.repType == 'M') return $g("�����걨");
		        else return value;
		    }else  if (value == 'CANCEL') {
		        return $g("����");
		    }else  if (value == 'AUDIT') {
		        return $g("����ȷ��");
		    }else  if (value == 'DIF') {
		        return $g("�����ȷ��");
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
		        return $g("��");
		    } else if (value == 'N') {
		        return "��";
		    }else  if (value == 'AUDIT') {
		        return $g("����ȷ��");
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
		
		/* �������屳��ɫ */
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
		
		/* ����������ʾֵ */
		DayFormatter : function(value, row, index){
			if (value.indexOf("-") >= 0) value = value.split("-")[0]
			return value
		}
	},
	
	/* �������������ڴ˶��� */
	OPERATE : {
		/* ���������� */
		ClearGrid : function(gridId){
			gridId = REP_COM.FUNCTION.GetNewId(gridId);
			$(gridId).datagrid('loadData', []);
		},
		
		/* ѡ��ĳ������ ����Ԫ��*/
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
	
	/* ������ȡ���ݻ��߲�ѯ�����ڴ˶��� */
	FUNCTION : {
		/* ��ȡ����ID */
		GetRepId : function (){
			var gridSelect = $('#gridRep').datagrid('getSelected') || '';
		    if (gridSelect) return gridSelect.repId;
		    return '';
		},
		
		/* ��ѯ���������¼ */
		QueryRepOperate : function(){
			var repId = REP_COM.FUNCTION.GetRepId()
			if(!repId) return;
			$('#gridRepOperate').datagrid('query', {
		        pJson : JSON.stringify({repId:repId})
		    });
		},
	
		/* ��ѯ��ҳǩ��ϸ����
		   input: isSelect = select  ��ʶ���л�ҳǩ���õĲ�ѯ
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
			
		    if (tabId == 'allDetail'){  			// ��ϸ��ϸ
			    gridId = '#gridRepInciAll';
			    retACheckId = '#onlyRetA';
			    inciAliasId = "inciAlias";
		    }else if (tabId == 'RpAmt'){  			// ������ϸ
				gridId = '#gridRpAmtDetail';
				statType = 'RpAmt'
				retACheckId = '#onlyRetARpAmt'
				inciAliasId = "inciAliasRpAmt";
		    }else if (tabId == 'SpAmt'){  			// �ۼ���ϸ
				gridId = '#gridSpAmtDetail';
				statType = 'RpAmt'
				retACheckId = '#onlyRetASpAmt'
				inciAliasId = "inciAliasSpAmt";
		    }else if (tabId == 'ScgRpAmt'){  		// �����������
				gridId = '#gridScgRpAmtTotal';
				statType = 'RpAmt'
		    }else if (tabId == 'ScgSpAmt'){  		// �ۼ��������
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
		
		/* ��ȡ��ID������#ǰ׺ */
		GetNewId : function (id){
			if (!id) return "";
			id = '#' + id;
			return id;
		},
		
		/* ����ȷ�� */
		AuditDif : function (){
			var repId = REP_COM.FUNCTION.GetRepId()
			if (repId == '') {
				PHA.Msg('alert','��ѡ��һ�������¼��')
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
		
		/* ���� */
		Cancel : function (){
			var repId = REP_COM.FUNCTION.GetRepId();
			if (repId == '') {
				PHA.Msg('alert','��ѡ��һ�������¼��')
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
			if (amtType == "RpAmt") amtDesc = "���۽��"
			else if (amtType == "SpAmt") amtDesc = "�ۼ۽��"
			return amtDesc;
		}
	},
	
	/* ��ʼ����� */
	INITGRID : {
			/* ��ʼ���������  */
			InitComGrid: function(){
				
				REP_COM.INITGRID.RepOperate('gridRepOperate');
				REP_COM.INITGRID.RepInci('gridRepInciAll', 'repInciAllBar');
				REP_COM.INITGRID.AmtDetail('gridRpAmtDetail', 'RpAmt', 'gridRpAmtDetailBar');
				REP_COM.INITGRID.AmtDetail('gridSpAmtDetail', 'SpAmt', 'gridSpAmtDetailBar');
				REP_COM.INITGRID.ScgAmtTotal('gridScgRpAmtTotal', 'RpAmt');
				REP_COM.INITGRID.ScgAmtTotal('gridScgSpAmtTotal', 'SpAmt');
				
				/* ��ʼ��ҳǩ�ؼ��� */
				$('#tabKw').keywords({
			        onClick:function(v){
				        REP_COM.FUNCTION.QueryRepDetail('select');
				    },
				    singleSelect: false,
			        items:[
			        	{text: '�л�ҳǩ�Զ�ˢ��',	id: "autoRefresh",	selected: false}
			        ]
				});	
				
				/* ���л�ҳǩ���� */
				$('#tabDetail').tabs({    
			        onSelect:function(title,index){    
			        	REP_COM.FUNCTION.QueryRepDetail('select');
			        }    
			 	});
			 	
			 	/* ��ʼ������ */
				for (i=0;i<REP_COM.DATA.TabalSuffix.length;i++){
				 	PHA_UX.ComboBox.INCItm('inciAlias' + REP_COM.DATA.TabalSuffix[i], {
						hasDownArrow: false,
						width:200,
						placeholder: 'ҩƷ����...',
					});	
				}
				
				/* ��ɸѡ��ť�¼� */
				PHA.BindBtnEvent('#gridRepBar');
				PHA.BindBtnEvent('#gridRpAmtDetailBar');
				PHA.BindBtnEvent('#gridSpAmtDetailBar');
			},
		
			/* ȫ����ϸ */
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
				if(i==0 || i==3 || i==4 ) leni = 1   	//������ڳ�����ĩ����ڶ���Ϊ�գ�������ֻ������
				for (j=0;j<leni;j++){
					if (i == 1){  						//ҵ������
						typeDataObj = busiTypeData[j]
					}
					else if(i == 2){  					//��������
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
		
		/* ������¼�б� */
		RepOperate : function(gridId) {
			var columns = [
		        [
		        	{ field: 'repoId', 		title: 'repoId', 	align: 'center', width: 80  ,hidden:true},
		        	{ field: 'status', 		title: '����״̬', 	align: 'center', width: 150  ,styler:REP_COM.FORMATTER.AllStateStyler,formatter:REP_COM.FORMATTER.AllStateFormatter},
		        	{ field: 'userName', 	title: '������Ա', 	align: 'left',   width: 80  },
		        	{ field: 'date', 		title: '��������', 	align: 'center', width: 120 },
		            { field: 'time', 		title: '����ʱ��', 	align: 'center', width: 120 },
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
		
		/* ���ۼ���ϸ�б� */
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
				{  	title:'�ڳ�' + amtDesc,	 field:'BEGIN' + amtType,  	align:'right',		colspan:1,			rowspan: 2, 	width: 100 ,formatter:REP_COM.FORMATTER.NumFormatter}, 
				{  	title:'ҵ������' + amtDesc,	 						align:'center',		colspan:busiLen,	halign:'center'	},
				{  	title:'��������' + amtDesc,	 						align:'center',		colspan:retALen,	halign:'center'	},
				{ 	title:'��ֹ' + amtDesc,	 field:'END' + amtType,		align:'right',		colspan:1,			rowspan: 2,		width: 100 ,formatter:REP_COM.FORMATTER.NumFormatter},
				{ 	title:'����' + amtDesc,	 field:'DIF' + amtType,		align:'right',		colspan:1,			rowspan: 2, 	width: 100 ,formatter:REP_COM.FORMATTER.NumFormatter,	styler:REP_COM.FORMATTER.DifNumStateStyler}
			]
			
			var dataType = REP_COM.DATA.DataType
			for (i=0;i<5;i++){
				lenNew = lenArr[i]
				if(lenNew == 1) continue;
				for (j=0;j<lenNew;j++){
					if (i == 1){  //ҵ������
						typeDataJson = busiTypeData[j]
					}
					else if(i == 2){  //��������
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

		/* ��������� */
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
				{  	title:'�ڳ�' + amtDesc,	 field:'BEGIN' + amtType,  	align:'right',		colspan:1,			rowspan: 2 , 	width: 100 ,formatter:REP_COM.FORMATTER.NumFormatter	}, 
				{  	title:'ҵ������' + amtDesc,	 						align:'center',		colspan:busiLen,	halign:'center'	},
				{  	title:'��������' + amtDesc,	 						align:'center',		colspan:retALen,	halign:'center'	},
				{ 	title:'��ֹ' + amtDesc,	 field:'END' + amtType,		align:'right',		colspan:1,			rowspan: 2 , 	width: 100 ,formatter:REP_COM.FORMATTER.NumFormatter	},
				{ 	title:'����' + amtDesc,	 field:'DIF' + amtType,		align:'right',		colspan:1,			rowspan: 2 , 	width: 100 ,formatter:REP_COM.FORMATTER.NumFormatter	,	styler:REP_COM.FORMATTER.DifNumStateStyler}
			]
			
			var dataType = REP_COM.DATA.DataType
			for (i=0;i<5;i++){
				lenNew = lenArr[i]
				if(lenNew==1) continue;
				for (j=0;j<lenNew;j++){
					if (i == 1){  //ҵ������
						typeDataJson = busiTypeData[j]
					}
					else if(i == 2){  //��������
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


 