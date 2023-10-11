/**
 * 名称:	 处方点评-点评处方-选择不合理原因
 * 编写人:	 pushuangcai
 * 编写日期: 2020/11/09
 * 备注:	 在页面初始化时调用InitDiagReason(type)
 *			 打开窗口调用showDialogSelectReason即可
 */
// 全局变量放在此对象中
var ReasonDialog = {
	$dialogObj: '',
	oeori: '',
	cntItem: '',
	type: "",
	callback: ''	
}

// 初始化
function InitDiagReason(type){
	PHA.ComboBox("conWarn", {
		url: PRC_STORE.Factor(),
		width:333
	});
	PHA.ComboBox("conAdvice", {
		url: PRC_STORE.PhaAdvice(),
		width:333
	});	
	InitReasonTree();
	InitGridLinkOrd();
	InitGridQuestion();
	InitDialogSelectReason();
	
	$("#btnSave").on("click", function () {
		saveReason() ;
	});
	
	ReasonDialog.type = type;
}

/** 
 * 从此处调用
 * @ReasonDialog.type(OP/IP)-门诊处方点评或住院医嘱点评 
 * @oeori：type为IP时为医嘱id，OP时为处方号
 * @pcntItm：点评子表id
 * @callback： 回调函数(如果需要更新原界面数据，在回调函数完成)
 */
function showDialogSelectReason(oeori, pcntItm, callback){
	ReasonDialog.$dialogObj.dialog('open');
	$('#gridLinkOrder').datagrid('query', {
	    input: oeori
	});
	if(ReasonDialog.oeori !== oeori){
		ClearQuestionGrid();
		InitReasonTree();
	}
	// 装载从其他界面传过来的全局变量
	ReasonDialog.oeori = oeori;
	ReasonDialog.cntItem = pcntItm;
	ReasonDialog.callback = callback;
}

// 从此处关闭，关闭dialog时清除全局变量和界面显示数据
function CloseDialogSelectReason(){
	ReasonDialog.oeori = "";
	ReasonDialog.cntItem = "";
	ReasonDialog.callback = "";
	ClearQuestionGrid();
	ReasonDialog.$dialogObj.dialog('close');
}

function InitReasonTree() {
	$.cm({
		ClassName: 'PHA.PRC.Com.Store',
		MethodName: 'GetPRCReasonTree',
		params: '',
		hospID: session['LOGON.HOSPID']
	},function(data){
		$('#gridReason').tree({
			lines: false,
			data: data,
			onDblClick: function(node){
				ReasonClickEvent(node);		
			}			
		});
	});
}

function InitGridLinkOrd() {
    var columns = [[
    	{ field: "ordDesc", title: '医嘱名称',width: 320, },
    	{ field: "orditm", title: 'orditm', width: 80, hidden :true },
    ]];
    var dataGridOption = {
        url: $URL,
        queryParams: {
            ClassName: 'PHA.PRC.Create.Main',
            QueryName: 'SelectOrdDetail',
			input :''
        },
        columns: columns,
        pagination: false,
        onDblClickRow: function(rowIndex, rowData){
			var orditm = rowData.orditm ;
			var ordDesc = rowData.ordDesc ;
			OrderClickEvent(orditm, ordDesc) ;
		}
		  
    };
    PHA.Grid("gridLinkOrder", dataGridOption);
}

//初始化表格-问题列表
function InitGridQuestion() {
    var columns = [[
        { field: "desc", title: '描述', width: 450,
        	formatter:function(v){
				return v.replace('└──','<span style="color:#999999">└──</span>')
			} },			
        { field: "level", title: '分级', width: 80, hidden:true },
		{ field: "rowid", title: 'rowid', width:100, hidden:true} 
    ]];
    var dataGridOption = {
        columns: columns,
        pagination: false,
        toolbar: "#gridQuestionBar",
        onDblClickRow:function(rowIndex,rowData){
	        var rows = $('#gridQuestion').datagrid('getRows');
	        var delRowIndArr = [rowIndex];
	        var tmpRowIndex = rowIndex;
	        if(rowData.level.trim() !== ""){
		        $('#gridQuestion').datagrid('deleteRow', rowIndex);	
		    	return;    
		    }
	        if((typeof rows[rowIndex -1] !== "undefined")&&(rows[rowIndex -1].level.trim() === "")){
			    $('#gridQuestion').datagrid('deleteRow', rowIndex);	
			}else{
				while((typeof rows[++tmpRowIndex] !== "undefined")&&(rows[tmpRowIndex].level.trim() !== "")){
					delRowIndArr.push(tmpRowIndex);
				}
				rows.splice(rowIndex, delRowIndArr.length);
				$('#gridQuestion').datagrid('loadData', rows); 
		    }
		},
		onRowContextMenu: function(){
			return false;	
		}    
    };
    PHA.Grid("gridQuestion", dataGridOption);
}

function InitDialogSelectReason(){
	ReasonDialog.$dialogObj = $('#diagSelectReason').dialog({
		title: "不合理原因" ,
		iconCls:  'icon-w-find' ,
		modal: true,
		closed: true,
		width: $('body').width()*0.9,
		isTopZindex:true ,
		height: $('body').height()*0.9
	})
}	
	
function ReasonClickEvent(node){
	if (node.isLeaf=="N"){
		var reasonId = node.id ;  	
		var reasonDesc = node.text ;
		if (reasonId == ""){
			return;
		}
		var gridChanges = $('#gridQuestion').datagrid('getRows');
		var gridChangeLen = gridChanges.length;
		for (var counter = 0; counter < gridChangeLen; counter++) {
			var quesData = gridChanges[counter];
			var selReasonId = quesData.rowid|| "" ;
			if (selReasonId == reasonId){
				PHA.Popover({ msg: '该原因已存在,不能重复添加', type: 'alert'});	
				return;		
			}		
		}
		$("#gridQuestion").datagrid('appendRow', {
			desc: reasonDesc ,
			level: '' ,
			rowid: reasonId
		});	
	}
	else{
		$('#gridReason').tree('toggle', node.target); //简单单吉展开关闭	
	}
}

function OrderClickEvent(selOrdItm, selOrdDesc){
	if (selOrdItm == ""){
		return;
	}
	var gridChanges = $('#gridQuestion').datagrid('getRows');
	var gridChangeLen = gridChanges.length;
	if (gridChangeLen == "0"){		
		PHA.Popover({ msg: '请先双击选择不合理原因,然后再重试！', type: 'alert'});	
		return;
	}
	var reasonRowId = "";
	/*for (var counter = 0; counter < gridChangeLen; counter++) {
		var quesData = gridChanges[counter];
		var selRowid = quesData.rowid|| "" ;
		if (selOrdItm == selRowid){
			PHA.Popover({ msg: '该医嘱已存在,不能重复添加！', type: 'alert'});	
			return;		
		}		
	}
	*/
	lastData = gridChanges[(gridChangeLen-1)]
	var lastRowId = lastData.rowid|| "" ;
	var selOrdDesc = "└──&nbsp;&nbsp;"+selOrdDesc
	$("#gridQuestion").datagrid('appendRow', {
		desc: selOrdDesc ,
		level: selOrdItm ,	
		rowid: selOrdItm
	});	
}

function saveReason(){
	var gridChanges = $('#gridQuestion').datagrid('getRows');
	var gridChangeLen = gridChanges.length;
	if (gridChangeLen == "0"){		
		PHA.Alert('提示', '请在问题列表中加入相关联的医嘱,然后再重试！', 'warning');
		return;
	}
	var reasonIdStr = ""
	var levelflag = 0; chkexistflag=0;
	for (var counter = 0; counter < gridChangeLen; counter++) {
		var quesData = gridChanges[counter];
		var selReasonId = quesData.rowid|| "" ;
		var selLevel = quesData.level|| "" ;
		var selDesc = quesData.desc|| "" ;
		var selDescData = selDesc.split("└──")
		var selDescVal = selDescData[1]
		if (selLevel != ""){
			if (reasonIdStr==""){
				PHA.Alert('提示', '请先添加'+ selDescVal +' 对应的不合理原因,然后再重试！', 'warning');
				return;	
			}
			reasonIdStr = reasonIdStr+"$$$"+selReasonId ;
		    levelflag = 1;
		    chkexistflag = 1;						
		}else {
			if (reasonIdStr == ""){
				reasonIdStr = selReasonId ;				
			}else {
				if (levelflag == 1){
					reasonIdStr = reasonIdStr +"!"+ selReasonId ;
		  			levelflag = 0;
				}else {
					reasonIdStr = reasonIdStr +"^"+ selReasonId ;				
				}
			}
		}
	}	
	if (chkexistflag==0){
		PHA.Alert('提示', '请在问题列表中加入相关联的医嘱,然后再重试！', 'warning');
		return;
	}	
	var factorId = $("#conWarn").combobox('getValue')||'';		//警示值
	var adviceId = $("#conAdvice").combobox('getValue')||''; 		//建议	
	var phnoteDesc = $.trim($("#conPhNote").val());				//备注
	var remarkStr = factorId+"^"+adviceId+"^"+phnoteDesc ;	
	var result = "N";
	var otherstr = ReasonDialog.oeori;
	var pcntItm = ReasonDialog.cntItem;
	
	if(ReasonDialog.callback){
		ReasonDialog.callback(pcntItm, result, longoninfo, reasonIdStr, remarkStr, otherstr);
	}
	CloseDialogSelectReason();
}

function ClearQuestionGrid(){
	$("#gridQuestion").datagrid("clear");
	$("#gridLinkOrder").datagrid("clear");
	$("#conWarn").combobox("setValue",'');
	$("#conWarn").combobox("setText", '');
	$("#conAdvice").combobox("setValue",'');
	$("#conAdvice").combobox("setText", '');
	$("#conPhNote").val('');	
}