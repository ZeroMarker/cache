/**
 * FileName: dhcbill\dc\checkresultnew.js
 * Author: zjb
 * Date: 2022-06-23
 * Description: 数据核查结果
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
			init_toolbar(newValue);
		}
	});
	$("#search").keydown(function (e) {
		var key = websys_getKey(e);
		if (key == 13) {
			loadDG();
		}
	});
	init_DG();
	$("#btnStopIndicator").click(StopIndicator);
	init_toolbar(defHospId);
	//init_ckDetDG();
	//loadDG();
	setDateBox();
});


function init_toolbar(newValue)
{
	$("#tools").keywords({
	    singleSelect:true,
	    onClick:function(v){
		  /*   loadDG() */
		    },
	    labelCls:'red',
	    items:[{text:'全部',id:'',selected:true}]
	});
	$.cm({
		ClassName: "BILL.DC.BL.DicDataCtl",
		QueryName: "QueryInfo",
		HospID: "G",
		KeyCode: "",
		PDicType: "ExceptionLevel",
		ExpStr:"",
		rows:100
		},function(jsonData){
			var keywordsArr=[{text:'全部',id:'',selected:true}];
			for(i=0;i<jsonData.rows.length;i++)
			{
				var keywords={text:jsonData.rows[i]["DicDesc"],id:jsonData.rows[i]["DicCode"]};
				keywordsArr.push(keywords);
			}
			$("#tools").keywords({
		        singleSelect:true,
		        onClick:function(v){loadDG()},
		        labelCls:'red',
		        items:keywordsArr
	    	});
	});
}

//停用指标
function StopIndicator()
{
	if(GV.MontList.getSelected()==null||GV.MontList.getSelected()["IndicatorCode"]==""){
	 $.messager.alert("警告","请选择要停用的指标!",'info');
	  return;
	}
	if(GV.MontList.getSelected()["EXlevelId"]=="L3")
	{
		$.messager.alert("警告","重要指标不允许停用!",'info');
	  	return;
	}
	$.messager.confirm("提示", "是否停用指标【" + GV.MontList.getSelected()["IndicatorName"] + "】？", function (r) { // prompt 此处需要考虑为非阻塞的
	if (r) {
		var Code=GV.MontList.getSelected()["IndicatorCode"]; 
		var BusinessCode=GV.MontList.getSelected()["BusinessCode"]; 
		var HospDr=getValueById("hospital");
		var saveinfo=Code+"^"+BusinessCode+"^"+HospDr;
		saveinfo=saveinfo.replace(/请输入信息/g,"")
		var savecode=tkMakeServerCall("BILL.DC.BL.IndicatorDefCtl","ChangeActiveFlagByCodeAndBusTC",saveinfo,session['LOGON.USERID']);
		if(savecode.split("^")[0]>0){
			$.messager.alert('提示','停用指标成功!','info');   
		}
		else
		{
			$.messager.alert('提示','停用指标失败!rtn=' + savecode,'info');   	
		}
	} else {
		return false;
	}
	})
}
function init_DG(){
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
		sortName:'CheckBatch,BusinessType,ExceptionNum',
		sortOrder:'desc',
		remoteSort:false,
		//fitColumns: true,
		//striped:true,
		pagination: false,
	    toolbar:'<div  class="hisui-toolbar datagrid-toolbar"><table cellspacing="0" cellpadding="0"><tbody><tr><td><a id="tools"></a></td></tr></tbody></table></div>',
		// IndicatorId,IndicatorCode,IndicatorName,CheckMode,CheckStartDate,CheckStartTime,CheckEndDate,CheckEndTime,CheckFlag,HospDr,CRTER,CRTEDATE,CRTETIME,UPDTID,UPDTDATE,UPDTTIME,Rowid,CheckBatch,ExceptionNum
		columns: [[
			{title: '核查批次', field: 'CheckBatch', width: 580,tipPosition:"top",showTip:true,sortable:true,
			formatter:function(val,row,index){
				var EXlevelName="("+row["EXlevelName"]+")";
				if(EXlevelName=="")
				{
					EXlevelName="("+"重要"+")";
				}
				
				if(row.IndicatorId){
					rtn=row.IndicatorId;
					rtn=rtn + " -- " +EXlevelName;
					
				}else{
					rtn=val
				}
				rtn=rtn +  row["IndicatorName"];
				if (row.ExceptionNum!="0" && row.IndicatorId)
				{
					rtn = '<a  href="#" onClick="loadConfPage('+'\''+row.Rowid +'\''+','+'\''+row.IndicatorId.replace(/[^a-zA-Z]/g,'') +'\''+','+'\''+ row.IndicatorCode +'\''+','+'\''+ row.ExceptionNum +'\''+')" >' + rtn +'</a>';//明细&nbsp
				}
				return rtn;
				
			}},
			{title: 'Rowid', field: 'Rowid', hidden: true}, // 
			{title: '业务类型', field: 'BusinessType', hidden: true},
			{title: '指标代码', field: 'IndicatorCode', width: 90, hidden: true},
			{title: '异常等级', field: 'EXlevelId', width: 90, hidden: true,
			formatter: function (value, row, index) {
			}},
			{hidden: true,title: '指标名称', field: 'IndicatorName', width: 280,tipPosition:"top",showTip:true,formatter: function (value, row, index){
				return value;
				/*var EXlevelName=row["EXlevelName"];
				if(EXlevelName=="")
				{
					EXlevelName="重要";
				}
				if (value == "")
				{
					return "";
				}
				else if (row.ExceptionNum=="0")
				{
					value="("+EXlevelName+")"+value
					return value;
				}
				else
				{
					value="("+EXlevelName+")"+value
					return '<a  href="#" onClick="loadConfPage('+'\''+row.Rowid +'\''+','+'\''+row.IndicatorId.replace(/[^a-zA-Z]/g,'') +'\''+','+'\''+ row.IndicatorCode +'\''+','+'\''+ row.ExceptionNum +'\''+')" ></a><label>'+value+'</label>';//明细&nbsp
				}*/
				}},
			{title: '异常数量', field: 'ExceptionNum', width: 90,sortable:true,sortOrder:'desc',
				sorter:function(a,b){
					var num1=parseFloat(a);
					var num2=parseFloat(b);
					return (num1>num2?1:-1);
				}
			},
			{title: '执行日期', field: 'CRTEDATE', width: 100},
			{title: '执行时间', field: 'CRTETIME', width: 90},
			{title: '数据开始日期', field: 'CheckStartDate', width: 100},
			{title: '数据开始时间', hidden: true, field: 'CheckStartTime', width: 100},
			{title: '数据结束日期', field: 'CheckEndDate', width: 100},
			{title: '数据结束时间', hidden: true, field: 'CheckEndTime', width: 100},
			{title: '核查方式', field: 'CheckMode', width: 80,
			formatter: function (value, row, index) {
				return (value == "S") ? "<font color='#21ba45'>系统</font>" : "<font color='#f16e57'>用户</font>";
			}},
			{title: '审核标志', field: 'CheckFlag', width: 80,
			formatter: function (value, row, index) {
				return (value == "Y") ? "<font color='#21ba45'>是</font>" : "<font color='#f16e57'>否</font>";
			}
			},
			{title: '业务代码', field: 'BusinessCode', hidden: true}
			
		]],
		onLoadSuccess: function(data) {
			//GV.MontList.unselectAll();
		},
		/* onSelect: function() {
			//var data=GV.MontList.getSelected();
		}, */
		onDblClickCell: function(data) {
			var data=GV.MontList.getSelected();
			if(!GV.MontList.getSelected()){
				return;
			}
			if(GV.MontList.getSelected().IndicatorId == ""){
				return;	
			}
			if (GV.MontList.getSelected().ExceptionNum == 0)
			{
				return;
			}
			loadConfPage(data.Rowid,data.IndicatorId.replace(/[^a-zA-Z]/g,''),data.IndicatorCode,data.ExceptionNum);
		},
		onClickRow:function(index,row)
		{
			changeIndexDesc(row["Description"]);
		},
		onLoadError:function(a){
			//alert(2)
		}
	});	
	
}

//默认时间
function setDateBox() {
	setValueById('StDate',getDefStDate(-7));
	setValueById('EdDate',getDefStDate(0));
}

function changeIndexDesc(IndexDesc)
{
	$("#IndexDesc").popover("destroy");
	if(IndexDesc!="")
	{
		$("#IndexDesc").popover({
			content: IndexDesc, 
			placement: 'auto', 
			trigger: 'hover',
			width:"500px"});
	}
}

function loadDG(){
	//ClearGrid("ckDet");
	$('#montList').treegrid('loadData',{total:0,rows:[]});
	/* var queryParams = {
					ClassName: GV.CKRCLASSNAME,
					QueryName: "QueryInfoGroup",
					HospID: getValueById("hospital"),
					keyCode: getValueById("search"),
					ParentID:""
		};
	loadTreeGridStore("montList", queryParams); */
	var level=$("#tools").keywords("getSelected");
	//var QEXlevelId=level[0]["id"];
	 $.cm({
		ClassName:GV.CKRCLASSNAME,
		QueryName:"QueryInfoGroup",
		HospID: getValueById("hospital"),
		keyCode: getValueById("search"),
		StDate: getValueById("StDate"),
		EdDate: getValueById("EdDate"),
		QEXlevelId:level[0]["id"],
		rows:9999
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


function loadConfPage(Rowid,IndicatorId,IndicatorCode,Total) {
/* 	if(!GV.MontList.getSelected()){
		return;
	}
	if(GV.MontList.getSelected().IndicatorId == ""){
		return;	
	}
	if (GV.MontList.getSelected().ExceptionNum == 0)
	{
		return;
	} */
	var setwidth=window.document.body.clientWidth*0.9;
	var setheigth = window.document.body.clientHeight*0.95;
	var OneAudit="N"
	if ((IndicatorId=="CT"&&IndicatorCode=="04")||(IndicatorId=="COM"&&IndicatorCode=="10"))
	{
		 OneAudit="Y"
	}
	var url = "dhcbill.dc.checkresultdetails.csp?&ParentID=" + Rowid + "&OneAudit="+ OneAudit+"&HosID="+getValueById("hospital")+"&Total="+Total+"&IndicatorId="+ IndicatorId+"&IndicatorCode="+IndicatorCode; 
	websys_showModal({
				url: url,
				title: "核查明细",
				closable:false,
				iconCls: "icon-w-edit",
				width: setwidth,
				height: setheigth,
				top: 50,
				left: 157,
				onClose: function()
				{
					loadDG();
				},

	});
	/* var _opt = {
		iconCls: 'icon-w-edit',
		title: '核查明细'
	}; 
	$("#edit-pt-dlg").show();
	
	var ptDlgObj = $HUI.dialog("#edit-pt-dlg", {
			iconCls: _opt.iconCls,
			title: _opt.title,
			draggable: false,
			resizable: false,
			modal: true,
			buttons: [
					{
				text: '关闭',
					handler: function () {
						ptDlgObj.close();
					}
				
				}],
				
				onBeforeOpen: function() {
					GetLoadDataDialog();
				
			}
		});
		 */
	
}
function serverToHtml(str) {
	return str.toString().replace(/<br\/>/g, "\r\n").replace(/&nbsp;/g, " ");
}

function htmlToServer(str) {
	return str.toString().replace(/(\r)*\n/g, "<br/>").replace(/\s/g, "&nbsp;");
}
//审核
function Audit(){
	var ckRows =  $('#ckDet').datagrid('getChecked');
	if (ckRows.length==0){
		$.messager.alert('提示','请勾选需要审核的错误项。','info');
		return;
	}
	$.messager.confirm('提示','是否继续操作' + ckRows.length + '条数据？',function(r){
		if(r){
			var getRows = $('#ckDet').datagrid('getRows');
			for (var i=0;i<getRows.length;i++){
				var row = getRows[i];
				var rowid = row['Rowid'];
				var ck = DCDataGrid.getCellVal('ckDet',i,'ck');
				ck = ck?"Y":"N"
				var UPDTDemo=getValueById('AuditDemo')||"无";
				var JsonObj = {"CheckFlag":ck,"UpdtDemo":UPDTDemo,"UpdtId":session['LOGON.USERID']}
				var jsonStr= JSON.stringify(JsonObj)
				var rtn = tkMakeServerCall("BILL.DC.BL.CheckResultDetCtl","UpdaeByJson",jsonStr,rowid);
			}	
			$.messager.alert('提示','审核成功','info');
			//loadConfPage();	
			GetLoadDataDialog();	
		}
	});
	
}
//数据核查结果导出
function Export()
{
   try
   {
	   	if(GV.MontList.getSelected()==null){
		   	 $.messager.alert("警告","请选择要导出的数据",'info');
			  return
		}
	   var KeyCodeValue=getValueById('dicKey')
		//window.open("websys.query.customisecolumn.csp?CONTEXT=KBILL.DC.BL.DicDataCtl:QueryInfo&PAGENAME=QueryInfo&HospID="+PUBLIC_CONSTANT.SESSION.HOSPID+"&KeyCode="+KeyCodeValue+"&PDicType="+$('#diccbx').combobox('getValue')==""?"SYS":$('#diccbx').combobox('getValue'));
		$.messager.progress({
	         title: "提示",
			 msg: '正在导出数据核查结果',
			 text: '导出中....'
			   });
		$cm({
			ResultSetType:"ExcelPlugin",  
			ExcelName:"数据核查结果",		  
			PageName:"QueryInfoGroup",      
			ClassName:GV.CKRCLASSNAME,
			QueryName:"QueryInfoGroup",
			HospID: getValueById("hospital"),
			StDate: getValueById("StDate"),
			EdDate: getValueById("EdDate"),
			//QEXlevelId:level[0]["id"],
			ParentID: GV.MontList.getSelected().CheckBatch,
			rows:999999
		},function(data){
			  setTimeout('$.messager.progress("close");', 3 * 1000);	
		});
		
   } catch(e) {
	   $.messager.alert("警告",e.message,'info');
	   $.messager.progress('close');
   }; 
}
function ClearGrid(gridid){
	$('#' + gridid).datagrid('loadData',{total:0,rows:[]});
	$('#' + gridid).datagrid('unselectAll');
	$('#' + gridid).datagrid('clearChecked');
}
/**
 * 根据入参获取对应grid的对象
 * @method loadDataGridStore
 * @param {String} gridIndex 表格序号 gridIndex 0:pat,1:,2:tar,3:ord
 * @param {type} 要获取指定表格的哪个对象/值【tr,td,field,td-div,tdHead,td】
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
	//设置datagrid的编辑器的值 可以使用setGridVal 进行赋值
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
    // 获取编辑框的值
    getCellVal: function (dg,index,field) {
		var rtn = '';
		var editor = $('#' + dg).datagrid('getEditor', {
      		index: index,
      		field: field
		});
		if(editor){ // 编辑器的值
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
		}else{ // 非编辑器的
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
				
			}else if(jObj[0].tagName=="A"){  //按钮修改显示值 2018-07-23 
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
    // 表格对象
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
				// 审核人
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
