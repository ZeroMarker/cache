/**
 * FileName: dhcbill.dc.checkresult.js
 * Author: tangzf
 * Date: 2022-05-17
 * Description: ���ݺ˲���
 */

var GV = {
	CKRCLASSNAME:"BILL.DC.BL.CheckResultCtl",
	CKRDCLASSNAME:"BILL.DC.BL.CheckResultDetCtl"
};

$(function() {
	var tableName = "User.INSUTarContrast";
	var defHospId = session['LOGON.HOSPID'];//2;//
	$("#hospital").combobox({
		panelHeight: 150,
		url: $URL + '?ClassName=web.DHCBL.BDP.BDPMappingHOSP&QueryName=GetHospDataForCombo&ResultSetType=array&tablename=' + tableName,
		method: 'GET',
		valueField: 'HOSPRowId',
		textField: 'HOSPDesc',
		editable: false,
		blurValidValue: true,
		onLoadSuccess: function(data) {
			$(this).combobox('select', defHospId);
		},
		onChange: function(newValue, oldValue) {
			loadDG();
		}
	});
	$("#search").keydown(function (e) {
		var key = websys_getKey(e);
		if (key == 13) {
			loadDG();
		}
	});
	$("#search1").keydown(function (e) {
		var key = websys_getKey(e);
		if (key == 13) {
			loadConfPage();
		}
	});


	//GV.MontList = $HUI.datagrid("#montList", {
	GV.MontList = $HUI.treegrid("#montList", {
		idField:'Rowid',
		rownumbers:true,
    	treeField:'CheckBatch',
		onDblClickRow:function(index,row){
			if(row.IndicatorId==""){
				if(row.state == "closed"){
					$(this).treegrid('expand',index);
				}else{
					$(this).treegrid('collapse',index);
				}
			}
		},
		fit: true,
		border: false,
		singleSelect: true,
		//fitColumns: true,
		pagination: true,
		pageList:[50,100],
		pageSize: 50,
		// IndicatorId,IndicatorCode,IndicatorName,CheckMode,CheckStartDate,CheckStartTime,CheckEndDate,CheckEndTime,CheckFlag,HospDr,CRTER,CRTEDATE,CRTETIME,UPDTID,UPDTDATE,UPDTTIME,Rowid,CheckBatch,ExceptionNum
		columns: [[
			{title: '�˲�����', field: 'CheckBatch', width: 180,showTip:true,
			formatter:function(val,row,index){
				var rtn = row.IndicatorId||val;
				
				return rtn;	
			}},
			{title: 'Rowid', field: 'Rowid', hidden: true}, // 
			{title: 'ҵ������', field: 'BusinessType', hidden: true},
			{title: 'ָ�����', field: 'IndicatorCode', width: 90, hidden: true},
			{title: 'ָ������', field: 'IndicatorName', width: 140,showTip:true},
			{title: '�쳣����', field: 'ExceptionNum', width: 65},
			{title: 'ִ������', field: 'CRTEDATE', width: 90},
			{title: '���ݿ�ʼ����', field: 'CheckStartDate', width: 90},
			{title: '���ݿ�ʼʱ��', field: 'CheckStartTime', width: 70},
			{title: '���ݽ�������', field: 'CheckEndDate', width: 90},
			{title: '���ݽ���ʱ��', field: 'CheckEndTime', width: 70},
			{title: '�˲鷽ʽ', field: 'CheckMode', width: 70,
			formatter: function (value, row, index) {
				return (value == "S") ? "<font color='#21ba45'>ϵͳ</font>" : "<font color='#f16e57'>�û�</font>";
			}},
			{title: '��˱�־', field: 'CheckFlag', width: 70,
			formatter: function (value, row, index) {
				return (value == "Y") ? "<font color='#21ba45'>��</font>" : "<font color='#f16e57'>��</font>";
			}
			},
			
			{title: 'ִ��ʱ��', field: 'CRTETIME', width: 70}
		]],
		onLoadSuccess: function(data) {
			GV.MontList.unselectAll();
		},
		onSelect: function() {
			loadConfPage();
		},
		onLoadError:function(a){
			//alert(2)
		}
	});
	init_ckDetDG();
	//loadDG();
});
function loadDG(){
	ClearGrid("ckDet");
	$.cm({
		ClassName:GV.CKRCLASSNAME,
		QueryName:"QueryInfoGroup",
		HospID: getValueById("hospital"),
		keyCode: getValueById("search"),
		StDate: getDefStDate(-1),
		EdDate:getDefStDate(0),
		rows:999999
	},function(jsonData){	
		var rows = 0;
		for (i=0;i<jsonData.rows.length;i++){
			if(jsonData.rows[i]._parentId == ""){
				jsonData.rows[i]['state']='closed';
				rows++;
			}
		};
		jsonData.total = rows;
		$('#montList').treegrid('loadData',jsonData);
	});
}
function init_ckDetDG(){
	$HUI.datagrid("#ckDet", {
		fit: true,
		border: false,
		singleSelect: false,
		pagination: true,
		pageSize: 999999,
		pageList:[999999],
		toolbar: '#dgTB',
		idField: 'Rowid',
		// IndicatorId,IndicatorCode,IndicatorName,CheckMode,CheckStartDate,CheckStartTime,CheckEndDate,CheckEndTime,CheckFlag,HospDr,CRTER,CRTEDATE,CRTETIME,UPDTID,UPDTDATE,UPDTTIME,Rowid,CheckBatch,ExceptionNum
		columns: [[
					{field:'ck',title:'���',width:65,align:'center',checkbox:true},
					{title: '������Ϣ', field: 'ErrInfo', width: 300,showTip:true},
					{title: 'ParID', field: 'ParID', hidden: true},
					{title: 'Rowid', field: 'Rowid', hidden: true},
				   {title: '������', field: 'DataSrc', width: 160},
				   {title: '��ID', field: 'DataID', width: 90},
				   {title: '�������', field: 'ErrCode', width: 90},
				   {title: 'ParNodeDataSrc', field: 'ParNodeDataSrc', width: 70, hidden: true},
				   {title: 'ParNodeDataID', field: 'ParNodeDataID', width: 90, hidden: true},
				   {title: 'ParNodeFlag', field: 'ParNodeFlag', width: 70, hidden: true},
				   {title: '��˱�־', field: 'CheckFlag', width: 70,
					formatter: function (value, row, index) {
						return (value == "Y") ? "<font color='#21ba45'>��</font>" : "<font color='#f16e57'>��</font>";
					}
				   },
				   {title: '��˱�ע', field: 'UPDTDemo', width: 90,showTip:true},
				   
				   {title: '�������', field: 'UPDTDATE', width: 90,
					formatter: function (value, row, index) {
						return (row.CheckFlag == "Y") ? value : "";
					}},
				   {title: '���ʱ��', field: 'UPDTTIME', width: 70,
					formatter: function (value, row, index) {
						return (row.CheckFlag == "Y") ? value : "";
					}},
				   {title: '�쳣��Ϣ', field: 'ErrConfInfo', width: 500,showTip:true}
			]],
		onLoadSuccess: function(data) {

		},
		onSelect: function(index, row) {
		}
	});
}


function loadConfPage() {
	if(!GV.MontList.getSelected()){
		return;
	}
	if(GV.MontList.getSelected().IndicatorId == ""){
		return;	
	}
	ClearGrid("ckDet");
	var queryParams = {
		ClassName: GV.CKRDCLASSNAME,
		QueryName: "QueryInfo",
		ParentID: GV.MontList.getSelected().Rowid,
		KeyCode:getValueById('search1'),
		PCheckFlag:(getValueById('CheckFlag')?"Y":"N")
	}
	loadDataGridStore("ckDet", queryParams);
}

function serverToHtml(str) {
	return str.toString().replace(/<br\/>/g, "\r\n").replace(/&nbsp;/g, " ");
}

function htmlToServer(str) {
	return str.toString().replace(/(\r)*\n/g, "<br/>").replace(/\s/g, "&nbsp;");
}
//���
function Audit(){
	var ckRows =  $('#ckDet').datagrid('getChecked');
	$.messager.confirm('��ʾ','�Ƿ��������' + ckRows.length + '�����ݣ�',function(r){
		if(r){
			var getRows = $('#ckDet').datagrid('getRows');
			for (var i=0;i<getRows.length;i++){
				var row = getRows[i];
				var rowid = row['Rowid'];
				var ck = DCDataGrid.getCellVal('ckDet',i,'ck');
				ck = ck?"Y":"N"
				var UPDTDemo=getValueById('AuditDemo')||"��";
				var JsonObj = {"CheckFlag":ck,"UpdtDemo":UPDTDemo,"UpdtId":session['LOGON.USERID']}
				var jsonStr= JSON.stringify(JsonObj)
				var rtn = tkMakeServerCall("BILL.DC.BL.CheckResultDetCtl","UpdaeByJson",jsonStr,rowid);
			}	
			$.messager.alert('��ʾ','��˳ɹ�','info');
			loadConfPage();		
		}
	});
	
}
function ClearGrid(gridid){
	$('#' + gridid).datagrid('loadData',{total:0,rows:[]});
	$('#' + gridid).datagrid('unselectAll');
	$('#' + gridid).datagrid('clearChecked');
}
/**
 * ������λ�ȡ��Ӧgrid�Ķ���
 * @method loadDataGridStore
 * @param {String} gridIndex ������ gridIndex 0:pat,1:,2:tar,3:ord
 * @param {type} Ҫ��ȡָ�������ĸ�����/ֵ��tr,td,field,td-div,tdHead,td��
 * @author tangzf
 */
 // DCDataGrid.setValueToEditor
var DCDataGrid={ 
	setGridVal:function(gridId,index,field,val){
		var gridViewArr = $('#' + gridId).siblings();
		var GridView2 = '';
		for (var gridIndex = 0; gridIndex < gridViewArr.length - 1; gridIndex++) {
			var GridClass = $(gridViewArr[gridIndex]).attr('class');
			if(GridClass.indexOf('view2') > 0){
				GridView2 = gridViewArr[gridIndex];		
			}
		}
	    var td = $(GridView2).find('.datagrid-body td[field="' + field + '"]')[index];
		var grid = $('#' + gridId);
        if (index === undefined || index === '') {
            index = 0;
        }
        var row = grid.datagrid('getRows')[index];
        if (row != null) {
            var editor = grid.datagrid('getEditor', {
                    index: index,
                    field: field
                });
            if (editor != null) {
                this.setValueToEditor(gridId, index,field,val);
            } else {
		        tmpdiv = $(td).find('div')[0];
		        if(tmpdiv){
			    	tmpdiv.innertText = val;
			    }
				$(tmpdiv).text(val);
            }
        }
	},
	//����datagrid�ı༭����ֵ ����ʹ��setGridVal ���и�ֵ
    setValueToEditor: function (dg,index,field, value) {
	    var editor = $('#' + dg).datagrid('getEditor', {
      		index: index,
      		field: field
		});
        switch (editor.type) {
        case 'combobox':
            editor.target.combobox('setValue', value);
            break;
        case 'combotree':
            editor.target.combotree('setValue', value);
            break;
        case 'textbox':
            editor.target.textbox('setValue', value);
            break;
        case 'numberbox':
            editor.target.numberbox("setValue", value);
            break;
        case 'datebox':
            editor.target.datebox("setValue", value);
            break;
        case 'datetimebox':
            editor.target.datebox("setValue", value);
            break;
        case 'switchbox':
            editor.target.switchbox("setValue", value);
            break;
        default:
            editor.html = value;
            editor.target[0].value = value; 
            break;
        }
    },
    // ��ȡ�༭���ֵ
    getCellVal: function (dg,index,field) {
		var rtn = '';
		var editor = $('#' + dg).datagrid('getEditor', {
      		index: index,
      		field: field
		});
		if(editor){ // �༭����ֵ
	        switch (editor.type) {
	        case 'combobox':
	            rtn = editor.target.combobox('getValue');
	            break;
	        case 'combotree':
	            rtn = editor.target.combotree('getValue');
	            break;
	        case 'textbox':
	            rtn = editor.target.textbox('getValue');
	            break;
	        case 'numberbox':
	            rtn = editor.target.numberbox("getValue");
	            break;
	        case 'datebox':
	            rtn = editor.target.datebox("getValue");
	            break;
	        case 'datetimebox':
	            rtn = editor.target.datebox("getValue");
	            break;
	        case 'switchbox':
	            rtn = editor.target.switchbox("getValue");
	            break;
	        case 'combogrid':
	            rtn = editor.target.combobox('getValue');
	            break;
	        default:
	            rtn = editor.target[0].value ; 
	            break;
	        }
		}else{ // �Ǳ༭����
			var rows = $('#' + dg).datagrid('getRows');
			rtn = rows[index][field];
			var gridViewArr = $('#' + dg).siblings();
			var GridView2 = '';
			for (var gridIndex = 0; gridIndex < gridViewArr.length - 1; gridIndex++) {
				var GridClass = $(gridViewArr[gridIndex]).attr('class');
				if(GridClass.indexOf('view2') > 0){
					GridView2 = gridViewArr[gridIndex];		
				}
			}
		    var view = GridView2;
			// 
			var Field = $(view).find('.datagrid-body td[field="' + field + '"]')[index];
			var divObj = $(Field).find('div')[0];
			var jObj = $(divObj).children(":first");
			var result = '';
			if(!jObj || (jObj && jObj.length == 0)){
				result = divObj.innerText; 
			}
	        else if (jObj[0].tagName=="INPUT"){
				var objType=jObj.prop("type");
				var objClassInfo=jObj.prop("class");
				if (objType=="checkbox"){
					//result=jObj.is(':checked')
					result = jObj.checkbox("getValue");
				}else if (objType=="select-one"){
					result=jObj.combobox("getValue");
				}else if (objType=="text"){
					if (objClassInfo.indexOf("combogrid")>=0){
						result=jObj.combogrid("getText");
					}else if (objClassInfo.indexOf("datebox-f")>=0){
						result=jObj.datebox('getText')
					}else if (objClassInfo.indexOf("combobox")>=0){
						result=jObj.combobox("getValue");
					}else if(objClassInfo.indexOf("number")>=0){
						result=jObj.numberbox("getValue");
					}
				}
			}else if(jObj[0].tagName=="SELECT"){
				var objClassInfo=jObj.prop("class");
				if (objClassInfo.indexOf("combogrid")>=0){
					result=jObj.combogrid("getText");
				}else if (objClassInfo.indexOf("combobox")>=0){
					result=jObj.combobox("getValue");
				}
			}else if(jObj[0].tagName=="LABEL"){
				result = jObj.text();
				
			}else if(jObj[0].tagName=="A"){  //��ť�޸���ʾֵ 2018-07-23 
				result = jObj.find(".l-btn-text").text();
			}else if(jObj[0].tagName=="TABLE"){  // editor
				var editInput = $(jObj).find('input');
				var objType=editInput.prop("type");
				var objClassInfo=editInput.prop("class");
				if (objType=="checkbox"){
					result = editInput.checkbox("getValue");
				}else if (objType=="select-one"){
					result=editInput.combobox("getValue");
				}else if (objType=="text"){
					if (objClassInfo.indexOf("combogrid")>=0){
						result = editInput.combogrid("getText");
					}else if (objClassInfo.indexOf("datebox-f")>=0){
						result = editInput.datebox('getText')
					}else if (objClassInfo.indexOf("combobox")>=0){
						result = editInput.combobox("getValue");
					}else if(objClassInfo.indexOf("number")>=0){
						result = editInput.numberbox("getValue");
					}else{
						result = editInput[0].value; 	
					}
				}
			}
	        rtn = result;	
		}
        return rtn;
    },
    // ������
    getTableObj:function(grid,index,type){
		var gridViewArr = $('#' + gridId).siblings();
		var GridView2 = '';
		for (var gridIndex = 0; gridIndex < gridViewArr.length - 1; gridIndex++) {
			var GridClass = $(gridViewArr[gridIndex]).attr('class');
			if(GridClass.indexOf('view2') > 0){
				GridView2 = gridViewArr[gridIndex];		
			}
		}
    	var tr = $(view).find('.datagrid-body tr[datagrid-row-index=' + index + ']');
		switch (type){ // gridIndex 0:pat,1:,2:tar,3:ord
		    case "tr" :
				// �����
				rtn = tr;
		    	break;
		    case "tdHead" :  
		    	tr = $(view).find('.datagrid-header-row');  
	 			td = $(tr).find('td[field="' + field + '"]');
	 			rtn = td;
		    	break;
		    case "td" :  
	 			td = $(tr).find('td[field="' + field + '"]');
	 			rtn = td;
		    	break;
			default :
	    		break;
		}
	}
}