/**
 * ����:	 ��������-��������-ѡ�񲻺���ԭ��
 * ��д��:	 pushuangcai
 * ��д����: 2020/11/09
 * ��ע:	 ��ҳ���ʼ��ʱ����InitDiagReason(type)
 *			 �򿪴��ڵ���showDialogSelectReason����
 */
// ȫ�ֱ������ڴ˶�����
var ReasonDialog = {
	$dialogObj: '',
	oeori: '',
	cntItem: '',
	type: "",
	callback: ''	
}

// ��ʼ��
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
 * �Ӵ˴�����
 * @ReasonDialog.type(OP/IP)-���ﴦ��������סԺҽ������ 
 * @oeori��typeΪIPʱΪҽ��id��OPʱΪ������
 * @pcntItm�������ӱ�id
 * @callback�� �ص�����(�����Ҫ����ԭ�������ݣ��ڻص��������)
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
	// װ�ش��������洫������ȫ�ֱ���
	ReasonDialog.oeori = oeori;
	ReasonDialog.cntItem = pcntItm;
	ReasonDialog.callback = callback;
}

// �Ӵ˴��رգ��ر�dialogʱ���ȫ�ֱ����ͽ�����ʾ����
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
    	{ field: "ordDesc", title: 'ҽ������',width: 320, },
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

//��ʼ�����-�����б�
function InitGridQuestion() {
    var columns = [[
        { field: "desc", title: '����', width: 450,
        	formatter:function(v){
				return v.replace('������','<span style="color:#999999">������</span>')
			} },			
        { field: "level", title: '�ּ�', width: 80, hidden:true },
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
		title: "������ԭ��" ,
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
				PHA.Popover({ msg: '��ԭ���Ѵ���,�����ظ����', type: 'alert'});	
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
		$('#gridReason').tree('toggle', node.target); //�򵥵���չ���ر�	
	}
}

function OrderClickEvent(selOrdItm, selOrdDesc){
	if (selOrdItm == ""){
		return;
	}
	var gridChanges = $('#gridQuestion').datagrid('getRows');
	var gridChangeLen = gridChanges.length;
	if (gridChangeLen == "0"){		
		PHA.Popover({ msg: '����˫��ѡ�񲻺���ԭ��,Ȼ�������ԣ�', type: 'alert'});	
		return;
	}
	var reasonRowId = "";
	/*for (var counter = 0; counter < gridChangeLen; counter++) {
		var quesData = gridChanges[counter];
		var selRowid = quesData.rowid|| "" ;
		if (selOrdItm == selRowid){
			PHA.Popover({ msg: '��ҽ���Ѵ���,�����ظ���ӣ�', type: 'alert'});	
			return;		
		}		
	}
	*/
	lastData = gridChanges[(gridChangeLen-1)]
	var lastRowId = lastData.rowid|| "" ;
	var selOrdDesc = "������&nbsp;&nbsp;"+selOrdDesc
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
		PHA.Alert('��ʾ', '���������б��м����������ҽ��,Ȼ�������ԣ�', 'warning');
		return;
	}
	var reasonIdStr = ""
	var levelflag = 0; chkexistflag=0;
	for (var counter = 0; counter < gridChangeLen; counter++) {
		var quesData = gridChanges[counter];
		var selReasonId = quesData.rowid|| "" ;
		var selLevel = quesData.level|| "" ;
		var selDesc = quesData.desc|| "" ;
		var selDescData = selDesc.split("������")
		var selDescVal = selDescData[1]
		if (selLevel != ""){
			if (reasonIdStr==""){
				PHA.Alert('��ʾ', '�������'+ selDescVal +' ��Ӧ�Ĳ�����ԭ��,Ȼ�������ԣ�', 'warning');
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
		PHA.Alert('��ʾ', '���������б��м����������ҽ��,Ȼ�������ԣ�', 'warning');
		return;
	}	
	var factorId = $("#conWarn").combobox('getValue')||'';		//��ʾֵ
	var adviceId = $("#conAdvice").combobox('getValue')||''; 		//����	
	var phnoteDesc = $.trim($("#conPhNote").val());				//��ע
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