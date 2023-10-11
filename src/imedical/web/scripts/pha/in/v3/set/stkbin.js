/**
 * ģ��:     ���һ�λ��ά��
 * ��д����: 2022-03-31
 * ��д��:   yangshijie
 */
 
var searchboxWidth = 133 ; //ģ��������Ŀ��
var gridIdArr = ['', 'gridFirst', 'gridSecond', 'gridThird'];
var qTextArr = ['', $g('����'), $g('��'), $g('��')];
var arrLen = gridIdArr.length;
var sbId = '';  //�༶��λ���ڵ������һ��RowId

$(function () {
    InitDict();
    InitGrid();
    ImportHandler();
    BindBtnEvent();
    QueryLoc();
});
function BindBtnEvent(){
	PHA_EVENT.Bind('#btnImportWin', 'click', function(){ImportWin();});
	PHA_EVENT.Bind('#btnImportFile', 'click', function(){ImportFile();});
	PHA_EVENT.Bind('#btnExportFile', 'click', function(){ExportFile();});
}

//��ʼ������
function InitSbData() {}

function InitDict() {
	/* ����ģ����ѯ */
    $('#locQText').searchbox({
	    searcher:function(value,name){
	    QueryLoc();
	    },
		width: 182,
	    prompt:$g('����ģ����ѯ...')
	});
	
	/* ����ģ����ѯ �������� */
	for (i=1;i<arrLen;i++){
		$('#' + gridIdArr[i] + 'QText' ).searchbox({
			width:searchboxWidth,
		    searcher:function(value,name){
			    var searchboxId = this.id;
			    var searchboxId = searchboxId.replace(/(#)|(QText)/g, ''); 
			    var level = gridIdArr.indexOf(searchboxId);
		    	QueryStkbin(level);
		    },
		    prompt: qTextArr[i] + $g('ģ����ѯ...')
		});
	}
	
	/* ҩƷģ����ѯ */
    $('#useQText').searchbox({
	    searcher:function(value,name){
	    QueryUseDrug(sbId);
	    },
	    prompt:$g('ҩƷģ����ѯ...')
	});
    $('#notUseQText').searchbox({
	    searcher:function(value,name){
	    QueryNotUseDrug(sbId);
	    },
	    prompt:$g('ҩƷģ����ѯ...')
	});
	
	/* ��λ������ 
	PHA.ComboTree('stkBinTree', {
        url: PHA_IN_STORE.StkBinTree().url
    });*/
     /* ��λ������ 
    PHA.ComboBox('stkBinComb', {
        url: PHA_IN_STORE.StkBinComb().url,
    });*/
    /* ���������� 
    PHA.ComboBox('stkBinRacks', {
        url: PHA_IN_STORE.StkBinRacks().url,
        multiple:true,
        rowStyle:'checkbox' //��ʾ�ɹ�ѡ����ʽ
    });*/
	
	/* ������ʾ��Ϣ */	
	var contentStr = "";
	// contentStr += $g("------------����Ϊ�û���ȡ------------");
	contentStr += $g("1.������λ��������ɣ��ֱ�Ϊ������(���ܺ�)����(���ܵ���һ��)����(һ�����һ��)�����λ�λ����ʱ����ʹ����ͬ���ȵ��ַ����������λ��ʾ���룬������ȹ̶�Ϊ2����1�Ż�λά����'01'")
	contentStr += "<br>" + $g("2.��λ��ά��ʱ������Ӣ���ַ������������ά��(�����λ�����򣬺����������)����ʹ���磺��A-01-01(��A���ܣ�01�㣬01��)")
	contentStr += "<br>" + $g("3.��λ��ά��ʱ������Ҫʹ�÷��� ����'-'�� ':',���ܻ���ɻ�λ��ʾ����")
	contentStr += "<br>" + $g("4.��λ�������ʾ��ʽΪ '����-��-��'")
	//contentStr += "<br>" + $g("------------����Ϊ������ȡ------------")
	//contentStr += "<br>" + $g("1.�����ṩ���ֻ�λ������ʽ��1).��(������),2).������(����)��3).������(�����ܺţ����̵�ʱʹ��)")
	$(".icon-help").popover({title:'��ܰ��ʾ',width:"400",content: contentStr});
	
	/*
	PHA_UX.ComboBox.Loc('phLocId');
	PHA_UX.ComboTree.stkBin('stkBinTree', {
		qParams: {
			LocId: PHA_UX.Get('phLocId', session['LOGON.CTLOCID'])
		}
	});
	*/
}

function InitDictRela(){
	return;
	var locId = GetLocId();
	if (!locId) return;
	$('#stkBinTree').combotree('clear');
    $('#stkBinTree').combotree('reload', PHA_STORE.StkBinTree(locId).url);
    $('#stkBinComb').combobox('reload', PHA_STORE.StkBinComb(locId).url);
    $('#stkBinRacks').combobox('reload', PHA_STORE.StkBinRacks(locId).url);
}


function InitGrid(){
	InitGridLoc();
	for (i=1;i<arrLen;i++){
		InitGridStkBin(i)
	}
	InitGridUseDrug();
	InitGridNotUseDrug();
}


/// ------------------- ��ѯ����---Start-----------------///
function QueryLoc(){
	Clear();
	var pJson = {
	    locQText:$('#locQText').searchbox('getValue') ,
	    hospId:PHA_COM.Session.HOSPID,
	    logLoc:PHA_COM.Session.CTLOCID,
	    groupId:PHA_COM.Session.GROUPID,
    }
	$('#gridLoc').datagrid('query', {
        pJsonStr : JSON.stringify(pJson),
    });
}

function QueryStkbin(level){
	/* ��ѯҩƷ���� */
	var parSbId = GetSbId(level - 1)
	QueryDrug(parSbId);
	
	ClearStkBin(level - 1);
	
	/* ��ѯ��λ��Ϣ */
	if (level >= arrLen) return;
	var locId = GetLocId();
	var qText = GetQText(level)
	var pJson = {
		locId  : locId,
		qText  : qText,
		parSbId: parSbId,
		level  : level
	}
    $('#' + gridIdArr[level]).datagrid('query', {
        pJsonStr : JSON.stringify(pJson),
    });
}

function QueryStkbinNext(level){
	if(level >= arrLen) return;
	QueryStkbin(level + 1)
}

function QueryDrug(sbId){
	if(!sbId) return;
	QueryUseDrug(sbId);
	QueryNotUseDrug(sbId);
}

function QueryUseDrug(sbId){
	var qText = $('#useQText').searchbox('getValue')
	$('#gridUseDrug').datagrid('query', {
        pJsonStr : JSON.stringify({sbId:sbId,qText:qText}),
    });
}
function QueryNotUseDrug(sbId){
	var qText = $('#notUseQText').searchbox('getValue')
	$('#gridNotUseDrug').datagrid('query', {
        pJsonStr : JSON.stringify({sbId:sbId,qText:qText}),
    });
}

function GetLocId(){
	var gridSelect = $('#gridLoc').datagrid('getSelected') || '';
    if (gridSelect) return gridSelect.RowId;
    return '';
}

function GetSbId(level){
	if (!level) return '';
	var gridSelect = $('#'+ gridIdArr[level]).datagrid('getSelected') || '';
    if (gridSelect) return gridSelect.sbId;
    return '';
}

function GetQText(level){
	return $('#'+ gridIdArr[level] + 'QText').searchbox('getValue') 
}
/// =================== ��ѯ���� === End =================== ///
/// ------------------- ������� --- Start-----------------///
function Clear()
{
	//ClearLoc();
	ClearStkBin(0);
}

function ClearLoc(){
    $('#gridLoc').datagrid('loadData', []);
}

function ClearStkBin(level){
	for (i=4;i>level;i--){
		var gridId = '#' + gridIdArr[i]
	    $(gridId).datagrid('loadData', []);
	    
	}
	ClearDrug();
}

function ClearDrug(){
	$('#gridUseDrug').datagrid('loadData', []);
	$('#gridNotUseDrug').datagrid('loadData', []);
}
/// =================== ������� === End =================== ///


/// ------------------- ����grid --- Start-----------------///

function InitGridLoc(){
	var columns = [
        [
            // RowId,Description
            { field: 'RowId', 			title: 'busiId', 		hidden: true },
            { field: 'Description', 	title: '��������', 		width: 50, 		align: 'left' },
        ]
    ];
    var pJson = {
	    locQText:'',
	    hospId:PHA_COM.Session.HOSPID,
	    logLoc:PHA_COM.Session.CTLOCID,
	    groupId:PHA_COM.Session.GROUPID,
    }
    var dataGridOption = {
        url: PHA.$URL,
        queryParams: {
            pClassName : 'PHA.STORE.Com', 
            pMethodName: 'GetGroupDept',
            pPlug	   : 'datagrid',
            pJsonStr   : JSON.stringify(pJson),
        },
        exportXls: false,
        fitColumns: true,
        fit: true,
        columns: columns,
        pagination: false,
        toolbar: '#gridLocBar',
        onClickRow: function (rowIndex, rowData) {
	        ClearStkBin(2);
            QueryStkbin(1);
            InitDictRela();
        }
    };
    PHA.Grid('gridLoc', dataGridOption);
}

function InitGridStkBin(level) {
    var columns = [
        [
            // sbId,level,sbDesc
            { field: 'sbId', 	title: 'sbId', 		hidden: true },
            { field: 'level', 	title: 'level', 	hidden: true },
            { field: 'sbDesc', 	title: '����', 		width: 50, 		align: 'left' ,
            	editor: PHA_GridEditor.ValidateBox({
					required: true
				})
			},
        ]
    ];
    var dataGridOption = {
        url: PHA.$URL,
        queryParams: {
            pClassName : 'PHA.IN.StkBin.Api',
            pMethodName: 'QueryLevelStkBin',
            pPlug	   : 'datagrid',
            pJsonStr   : JSON.stringify({}),
        },
        gridSave: false,
        exportXls: false,
        fitColumns: true,
        fit: true,
        isCellEdit: false,
        columns: columns,
        pagination: false,
        toolbar: '#' + gridIdArr[level] + 'Bar',
        onClickRow: function (rowIndex, rowData) {
	        if (!PHA_GridEditor.EndCheck(gridIdArr[level])) return;
	        ClearStkBin(level + 1)
            QueryStkbinNext(level);
            sbId = rowData.sbId;
        },
        onDblClickRow: function (rowIndex, rowData) {
	        if (rowData) {
		     	if (!PHA_GridEditor.EndCheck(gridIdArr[level])) return;
		        PHA_GridEditor.Edit({
					gridID: gridIdArr[level],
					index: rowIndex,
					field: 'sbDesc'
				});
            }
        }
    };
    PHA.Grid(gridIdArr[level], dataGridOption);
}

function InitGridUseDrug(){
	var columns = [
        [
            // sbiId,incil,inciCode,inciDesc,sbDesc
            { field: 'sbiId', 		title: 'sbiId', 		hidden: true },
            { field: 'incil', 		title: 'incil', 		hidden: true },
            { field: 'deleteBut',   title: 'ɾ��',          width: 59,			align: 'center',	formatter: deleteSbiFormatter,	frozencols:true	},
            { field: 'inciCode', 	title: 'ҩƷ����', 		width: 150, 		align: 'left' },
            { field: 'inciDesc', 	title: 'ҩƷ����', 		width: 250, 		align: 'left' },
            { field: 'sbDesc', 		title: '��λ', 			width: 200, 		align: 'left' }
        ]
    ];
    var dataGridOption = {
        url: PHA.$URL,
        queryParams: {
            pClassName : 'PHA.IN.StkBin.Api', 
            pMethodName: 'QueryUseDurg',
            pPlug	   : 'datagrid',
            pJsonStr   : '{}',
        },
        gridSave:false,
        exportXls: false,
        fitColumns: false,
        fit: true,
        columns: columns,
        pagination: true,
        idField: 'sbiId',
        toolbar: '#gridUseDrugBar',
        onClickRow: function (rowIndex, rowData) {}
    };
    PHA.Grid('gridUseDrug', dataGridOption);
}

function deleteSbiFormatter(value, rowData, rowIndex) {
	    var sbiId = rowData.sbiId;
		return (
			'<span class="icon icon-cancel"  onclick="DeleteDrug(\'' +
			sbiId +
			'\')">&ensp;</span>'
		);
	}


function InitGridNotUseDrug(){
	var columns = [
        [
            // sbiId,incil,inciCode,inciDesc,sbDesc
            { field: 'incil', 		title: 'incil', 		hidden: true },
	        { field: 'addBut',      title: '���',          width: 59,			align: 'center',	formatter: AddDrugFormatter,	frozencols:true	},
            { field: 'inciCode', 	title: 'ҩƷ����', 		width: 150, 		align: 'left' },
            { field: 'inciDesc', 	title: 'ҩƷ����', 		width: 250, 		align: 'left' },
            { field: 'sbDesc', 		title: '��λ', 			width: 200, 		align: 'left' }
        ]
    ];
    var dataGridOption = {
        url: PHA.$URL,
        queryParams: {
            pClassName : 'PHA.IN.StkBin.Api', 
            pMethodName: 'QueryNotUseDurg',
            pPlug	   : 'datagrid',
            pJsonStr   : '{}',
        },
        gridSave:false,
        exportXls: false,
        fitColumns: false,
        fit: true,
        columns: columns,
        pagination: true,
        idField: 'incil',
        toolbar: '#gridNotUseDrugBar',
        onClickRow: function (rowIndex, rowData) {}
    };
    PHA.Grid('gridNotUseDrug', dataGridOption);
}

function AddDrugFormatter(value, rowData, rowIndex) {
    var incil = rowData.incil;
	return (
        '<span class="icon icon-add" style="cursor:pointer;width: 24px;height: 16px;display: inline-block;" onclick="AddDrug(\'' +
        incil +
        '\')">&ensp;</span>'
    );
}

/// =================== ����grid === End =================== ///

/// -------------------������ --- Start------------------------///
// ������λ
function Add(level){
	if (!level){
		HA.Msg('alert' ,'��λ�ȼ�����Ϊ�գ�');
	    return;
	}
	var locId = GetLocId();
	var parSbId = GetSbId(level - 1);
	if (level == 1) {
		if((!locId)){
	    	PHA.Msg('alert' ,'��ѡ��һ�����ң�');
	    	return;
		}
    }else if (!parSbId){
	    PHA.Msg('alert' ,'��һ����λΪ�գ�');
	    return;
    }
	PHA_GridEditor.Add({
		gridID: gridIdArr[level],
		field: 'sbDesc',
		checkRow: true
	});
}

/// =================������ === End ===================///

/// ---------------����+ɾ�� --- Start-----------------///
// �����λ
function SaveSb(level) {
	if (!level){
		HA.Msg('alert' ,'��λ�ȼ�����Ϊ�գ�');
	    return;
	}
	var locId = GetLocId();
	var parSbId = GetSbId(level - 1);
	if (level == 1) {
		if((!locId)){
	    	PHA.Msg('alert' ,'��ѡ��һ�����ң�');
	    	return;
		}
    }else if (!parSbId){
	    PHA.Msg('alert' ,'��һ����λΪ�գ�');
	    return;
    }
    if (!PHA_GridEditor.EndCheck(gridIdArr[level])) return;
    var gridChanges = $('#'+ gridIdArr[level]).datagrid('getChanges');
    var gridChangeLen = gridChanges.length;
    if (!gridChangeLen){
	    PHA.Msg('alert' ,'û����Ҫ��������ݣ�');
	    return;
    }
    var pJson = {
	    locId : locId,
	    parSbId : parSbId,
	    level : level,
	    rows  : gridChanges
    }
    PHA.CM(
        {
            pClassName : 'PHA.IN.StkBin.Api',  
            pMethodName: 'SaveSb',
            pJsonStr   : JSON.stringify(pJson),
        },
        function (retData) {
	        if (PHA.Ret(retData)) {
				QueryStkbin(level);
			}
        }
    )
}

// ɾ����λ
function DeleteSb(level) {
	var gridId = '#' + gridIdArr[level]
	var gridSelect = $(gridId).datagrid('getSelected') || '';
    if (!gridSelect) {
        PHA.Msg('alert', '��ѡ��һ����λ' );
        return;
    }
    var sbId = gridSelect.sbId || '';
    if (sbId == '') {
        var rowIndex = $(gridId).datagrid('getRowIndex', gridSelect);
        $(gridId).datagrid('deleteRow', rowIndex);
        return;
    }
    var msgTitle = '��ȷ��ɾ����'
    
   var retData = PHA.CM(
        {
            pClassName : 'PHA.IN.StkBin.Api',  
            pMethodName: 'CheckSbDurg',
            pJsonStr   : JSON.stringify({sbId: sbId}),
        },
        false
    );
    if (retData.code < 0) {
        PHA.Msg('alert', retData.msg );
        return;
    }
    else if (retData.data){
        msgTitle = '�û�λ�ϻ����¼���λ���Ѿ�ά��ҩƷ��' + msgTitle;
    }
    $.messager.confirm('ȷ�϶Ի���', msgTitle, function (r) {
        if (r) {
            PHA.CM(
                {
                    pClassName : 'PHA.IN.StkBin.Api',  
		            pMethodName: 'DeleteSb',
		            pJsonStr   : JSON.stringify({sbId: sbId}),
                },
                function (retData) {
	                if (PHA.Ret(retData)) {
		                QueryStkbin(level);
		            } 
                }
            );
        }
    });	
}

// ɾ��ҩƷ
function DeleteDrug(sbiId) {
	if(!sbiId){
		PHA.Msg('alert', '��ѡ��һ��ҪҩƷ' );
        return;
	}
	$.messager.confirm('ȷ�϶Ի���', '��ȷ��ɾ����', function (r) {
        if (r) {
            PHA.CM(
                {
                    pClassName : 'PHA.IN.StkBin.Api',  
		            pMethodName: 'DeleteDrug',
		            pJsonStr   : JSON.stringify({sbiId: sbiId}),
                },
                function (retData) {
	                if (PHA.Ret(retData)) {
		                QueryDrug(sbId);
		            } 
                }
            );
        }
    });
}
// ɾ��ҩƷ
function AddDrug(incil) {
	if(!incil){
		PHA.Msg('alert', '��ѡ��һ��ҩƷ' );
        return;
	}
    PHA.CM(
        {
            pClassName : 'PHA.IN.StkBin.Api',  
            pMethodName: 'AddDrug',
            pJsonStr   : JSON.stringify({incil: incil,sbId:sbId}),
        },
        function (retData) {
            if (PHA.Ret(retData)) {
                QueryDrug(sbId);
            } 
        }
    );

}

/// =====================����+ɾ�� === End ================///


function ImportWin(){
	PHA.DomData('#ExportWin', {doType: 'clear'});
	$('#ImportWin')
    .dialog({
        iconCls: 'icon-w-import',
        modal: true,
        onBeforeClose: function () {},
    })
    .dialog('open');
}


function ImportHandler() {
	$('#conFileBox').filebox({
		prompt: $g('��ѡ���ļ�...'),
		buttonText: $g('ѡ��'),
		width: 250,
		accept: 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet,application/vnd.ms-excel'
	})
}

function ImportFile(){
	var filelist = $('#conFileBox').filebox('files');
	if (filelist.length == 0) {
		PHA.Msg('alert', '����ѡ���ļ���' );
		return;
	}
	var file = filelist[0];
	PHA_COM.ReadExcel(file,function(xlsData){
		var pJson = JSON.stringify({rows: xlsData});
		var pJson = ReplaceStr(pJson);
		
		PHA.CM(
	        {
	            pClassName : 'PHA.IN.StkBin.Api',  
	            pMethodName: 'ImportFile',
	            pJson      : pJson,
	        },
	        function (retData) {
	            if (PHA.Ret(retData)) {
	                $('#ImportWin').dialog('close');
	            } 
	        }
	    );
	});
}

function ReplaceStr(str){
	var str = str.replace(/#��������#/g, 'locDesc');
	var str = str.replace(/#����#/g, 'jia');
	var str = str.replace(/#��#/g, 'ceng');
	var str = str.replace(/#��#/g, 'lie');
	var str = str.replace(/#ҩƷ����#/g, 'inciCode');
	var str = str.replace(/#ҩƷ����#/g, 'inciDesc');
	return str;
}

function ExportFile(){
	var title={
		locDesc	 : '#��������#',
		jia		 : '#����#',
		ceng	 : '#��#',
		lie		 : '#��#',
		inciCode : '#ҩƷ����#',
		inciDesc : '#ҩƷ����#',
	}
	var data = [
		{
			locDesc	 : '��ҩ��',
			jia		 : '��1',
			ceng	 : '��1',
			lie		 : '',
			inciCode : 'XWY000002',
			inciDesc : '�������ι೦Һ(����)[133ml]',
		}, 
		{
			locDesc	 : '��ҩ��',
			jia		 : '��2',
			ceng	 : '��2',
			lie		 : '��2',
			inciCode : 'XWY000003',
			inciDesc : '���ᶡ���򽺽�(����)[5G]',
		}
	]
	var fileName='���һ�λ�뵼��ģ��.xlsx'
	PHA_COM.ExportFile(title, data, fileName);
}