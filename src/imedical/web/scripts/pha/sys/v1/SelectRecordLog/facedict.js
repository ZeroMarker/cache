var GridCmbPharmacy="";
var Com_HospId=session['LOGON.HOSPID'];
$(function () {
	InitHosp();
	InitGridDict();
	InitFaceDictGrid();
	
	InitEvent();
	HelpInfo();
})
function InitGridDict(){
	 $HUI.validatebox("#conAlias", {
		placeholder:"����/����/������/��/����"
	});
	GridCmbPharmacy = PHA.EditGrid.ComboBox({
		required: true,
        tipPosition: 'top',
       	url:PHA_STORE.Pharmacy().url,
        defaultFilter: 5,
        mode:'remote',
        onSelect: function (index, rowData) {
            var editIndex = $("#gridFaceDict").datagrid('options').editIndex;
            if (editIndex == undefined) {
                return;
            }
            var faceUseLocId = $(this).combobox("getValue");  //��ǰcombobox��ֵ
            if ((faceUseLocId == "") || (faceUseLocId == null)) {
                return;
            }
            var gridSelect = $('#gridFaceDict').datagrid("getSelected");            
            gridSelect.faceUseLocId = faceUseLocId;
        },
	    onBeforeLoad: function(param) {
            if (param.q == undefined) {
                param.q = $('#gridFaceDict').datagrid("getSelected").faceUseLoc;
            }
            param.QText = param.q; 
            param.HospId = Com_HospId; 
        }
	
	})
}
function InitEvent(){
	$('#btnFind').on('click', QueryFaceDict);
	$('#btnAdd').on('click', function () {
        $('#gridFaceDict').datagrid('addNewRow', {
            editField: 'faceCode'
        });
    });
    $('#btnSave').on('click', SaveFaceDict);
    $('#btnDelete').on('click', DelFaceDict);
    
    

}
function InitHosp(){
	var hospComp = GenHospComp("PHA-OP-LocConfig");  
	hospComp.options().onSelect = function(record){
		Com_HospId=$("#_HospList").combogrid('getValue') || "";;
		QueryFaceDict();
	}
}
function InitFaceDictGrid(){
	var columns = [[
		{
            field: 'faceRowId',
            title: '�ӿ��ֵ�id',
            hidden: true,
            width: 100
        },
        {
            field: 'faceCode',
            title: '�ӿڴ���',
            descField: 'faceCode',
            width: 60,
            editor: {
	        	type: 'validatebox',
	        	options: {
	                required: true
                }            
	        }
        },
        {
            field: 'faceDesc',
            title: '�ӿ�����',
            width: 150,
            editor: {
	        	type: 'validatebox',
	        	options: {
	                required: true
                }
	        }
        },{
            field: 'faceUseLoc',
            title: '����',
            descField: 'faceUseLoc',
            width: 150,
            editor: GridCmbPharmacy,
            formatter: function(value, row, index) {
                return row.faceUseLoc;
            }
        },
        {
            field: 'faceUseLocId',
            title: '��������',
            width: 100,
            hidden: true
       
        },
        {
            field: 'className',
            title: '�ӿ���',
            width: 220,
            editor: {
	        	type: 'validatebox',
	        	options: {
	                required: true
                }
	        }
        },
        {
            field: 'methodName',
            title: '�ӿڷ���',
            descField: 'methodName',
            width: 150,
            editor: {
	        	type: 'validatebox',
	        	options: {
	                required: true
                }
	        }
        },
        {
            field: 'remarks',
            title: '��ע',
            width: 150,
            editor: {
	        	type: 'validatebox'
                
	        }
        },
        {
            field: 'activeFlag',
            title: '����',
            width: 100,
            align: 'center',
            formatter: FormatterCheck,
            editor: {
		        type: 'icheckbox',
		        options: {
		            on: 'Y',
		            off: 'N'
		        }
		    }
        },
        {
            field: 'runMethod',
            title: '�෽��'
        }
	]];
	var dataGridOption = {
        url: $URL,
       
        queryParams: {
            ClassName: 'PHA.SYS.FaceDict.Query',
            QueryName: 'QueryFaceDict',
            pJsonStr: JSON.stringify({hospId: Com_HospId}),
            rows: 999
        },
        pagination: false,
        columns: columns,
        toolbar: '#gridFaceDictBar',
        enableDnd: false,
        fitColumns: false,
        rownumbers: true,
        exportXls: false,
        onClickRow: function (rowIndex, rowData) {
            $(this).datagrid('endEditing');
            
        },
        onDblClickRow: function (rowIndex, rowData) {
            if (rowData) {
                $(this).datagrid('beginEditRow', {
                    rowIndex: rowIndex,
                    editField: 'faceCode'
                });
            }
        },
        onLoadSuccess: function (data) {
        }
    };

    PHA.Grid('gridFaceDict', dataGridOption);
}
function QueryFaceDict(){
	var pJson = {};
	pJson.hospId = Com_HospId;	
	pJson.inputStr = $('#conAlias').val()||"";;
	$("#gridFaceDict").datagrid("query",{
		pJsonStr: JSON.stringify(pJson),
		
	});
}
function SaveFaceDict(){
	var $grid = $('#gridFaceDict');
    if ($grid.datagrid('endEditing') == false) {
        PHA.Popover({
            msg: '������ɱ�����',
            type: 'alert'
        });
        return;
    }
    var repeatObj = $grid.datagrid('checkRepeat', [['faceCode','faceUseLoc']]);
    if (typeof repeatObj.pos === 'number') {
        PHA.Popover({
            msg: '��' + (repeatObj.pos + 1) + '��' + (repeatObj.repeatPos + 1) + '��:' + repeatObj.titleArr.join('��') + '�ظ�',
            type: 'alert'
        });
        return;
    }
    var dataArr = [];
    var gridChanges = $grid.datagrid('getChanges',"updated");
    var gridChangeLen = gridChanges.length;
    for (var i = 0; i < gridChangeLen; i++) {
        var rowData = gridChanges[i];
        var iJson = {
	  		faceRowId:rowData.faceRowId || '',
	  		faceCode:rowData.faceCode ,
            faceDesc:rowData.faceDesc,
            userLocId:rowData.faceUseLocId,
            className:rowData.className,
            methodName:rowData.methodName,
            remarks:rowData.remarks || '',
            activeFlag:rowData.activeFlag
        };
        dataArr.push(iJson);
    }
    var gridChanges = $grid.datagrid('getChanges',"inserted");
    var gridChangeLen = gridChanges.length;
    for (var i = 0; i < gridChangeLen; i++) {
         var rowData = gridChanges[i];
        var iJson = {
	  		faceRowId:rowData.faceRowId || '',
	  		faceCode:rowData.faceCode ,
            faceDesc:rowData.faceDesc,
            userLocId:rowData.faceUseLocId,
            className:rowData.className,
            methodName:rowData.methodName,
            remarks:rowData.remarks || '',
            activeFlag:rowData.activeFlag
        };
        dataArr.push(iJson);
    }
    if (dataArr.length === 0) {
        PHA.Popover({
            msg: 'û����Ҫ���������',
            type: 'alert'
        });
        return;
    }
    var retJson = $.cm(
        {
            ClassName: 'PHA.COM.DataApi',
            MethodName: 'HandleInOne',
            pClassName: 'PHA.SYS.FaceDict.Save',
            pMethodName: 'SaveFaceDict',
            pJsonStr: JSON.stringify(dataArr)
        },false
    );

    if (retJson.success === 'N') {
	    msg=PHA_COM.DataApi.Msg(retJson)
        PHA.Alert('��ʾ', msg, 'warning');
        return;
    }else{
	    PHA.Popover({
	        msg: '����ɹ�',
	        type: 'success'
	    });
    }
	$grid.datagrid('reload');
}
function DelFaceDict(){
	var $grid = $('#gridFaceDict');
	var gridSelect = $grid.datagrid('getSelected') || '';
    if (gridSelect == '') {
        PHA.Popover({
            msg: '����ѡ����Ҫɾ������',
            type: 'alert',
            timeout: 1000
        });
        return;
    }
    var faceRowId = gridSelect.faceRowId || '';
    if(faceRowId!==""){
	   PHA.Popover({
	        msg: '�ѱ������ݲ���ɾ����¼��',
	        type: 'alert',
            timeout: 1000
	    });
	    return
    }
    PHA.Popover({
        msg: 'ɾ���ɹ�',
        type: 'success'
    });
 	var rowIndex = $grid.datagrid('getRowIndex', gridSelect);
   	$grid.datagrid('deleteRow', rowIndex);
}
function Clean(){}
function FormatterCheck(value, row, index) {
	if (value === 'Y' || value === '1') {
	    return PHA_COM.Fmt.Grid.Yes.Chinese;
	} else {
	    return PHA_COM.Fmt.Grid.No.Chinese;
	}
}
function HelpInfo(){
	$("#btnHelp").popover({
		title:'��Ƕ��ӿ�',
		trigger:'hover',
		padding:'10px',
		width:650,
		content:'<div>'
			   +'<p >101--���ʹ�������ҩ  </p >'
			   +'<p class="pha-row">110--��ҩ��  </p >'
			   +'<p class="pha-row">102--�շѺ󱨵�(��ѯ)  </p >'
			   +'<p class="pha-row">1021--�շѺ󱨵�(����)  </p >'
			   +'<p class="pha-row">103--�к�����  </p >'
			   +'<p class="pha-row">104--��ҩ���  </p >'
			   +'<p class="pha-row">105--ˢ������  </p >'
			   +'<p class="pha-row">106--��ҩ��ѯ�кŹ���  </p >'
			   +'<p class="pha-row">107--�к�����  </p >'
			   +'<p class="pha-row">108--��ҩʱ����  </p >'
			   +'<p class="pha-row">109--��ʱ����  </p >'
			   +'</div>'
	});	
	 
}