
$(function () {
	InitHosp();
	InitDict();
	InitPrescTypeGrid();
	
	InitEvent();
	HelpInfo();
})
function InitDict(){
	 PHA.ComboBox('conLoc', { 
	 	url: PHA_STORE.DocLoc().url 
	 });
	 PHA.ComboBox('docLoc', { 
	 	width:200,
	 	url: PHA_STORE.DocLoc().url 
	 });
	 PHA.ComboBox('prescType', { 
	 	width:200,
	 	url: PHA_STORE.ComDictionary("PrescType").url 
	 });
	 PHA.ComboBox('phcPoison', { 
	 	width:200,
	 	url: PHA_STORE.PHCPoison().url 
	 });
}
function InitEvent(){
	$('#btnFind').on('click', QueryPrescType);
	$('#btnAdd').on('click', function () {
        ShowDiagPrescType(this);
    });
    $('#btnEdit').on('click', function () {
        ShowDiagPrescType(this);
    });
    $('#btnDelete').on('click', DelPrescType);
    
    

}
function InitHosp(){
	var hospComp = GenHospComp();  
	hospComp.options().onSelect = function(record){
		PHA_COM.Session.HOSPID=$("#_HospList").combogrid('getValue') || "";;
		$('#conLoc').combobox('options').url = PHA_STORE.DocLoc().url;
        $('#conLoc').combobox('clear').combobox('reload');
        $('#docLoc').combobox('options').url = PHA_STORE.DocLoc().url;
        $('#docLoc').combobox('clear').combobox('reload');
		QueryPrescType();
	}
}
function InitPrescTypeGrid(){
	var columns = [[
		{
            field: 'ptId',
            title: 'ptId',
            hidden: true,
            width: 100
        },{
            field: 'prescType',
            title: '��������Dr',
            hidden: true,
            width: 100
        },
        {
            field: 'preacTypeDesc',
            title: '��������',
            descField: 'PreacTypeDesc',
            width: 100
        },{
            field: 'docLocId',
            title: 'ҽ������',
            descField: 'docLocId',
            hidden: true,
            width: 150
        },{
            field: 'docLocDesc',
            title: 'ҽ������',
            descField: 'docLocDesc',
            width: 150
        },
        {
            field: 'rangeAge',
            title: '���䷶Χ(��)',
            width: 150
        },{
            field: 'poisonDr',
            title: '���Ʒ���id',
            descField: 'poisonDr',
            width: 150,
            hidden: true
        },
        {
            field: 'posionDesc',
            title: '���Ʒ���',
            width: 150
        }
	]];
	var dataGridOption = {
        url: $URL,
        queryParams: {
            ClassName: 'PHA.OP.PrescType.Query',
            QueryName: 'QueryPrescType',
            pJsonStr: JSON.stringify({hospId: PHA_COM.Session.HOSPID}),
            rows: 999
        },
        pagination: false,
        columns: columns,
        toolbar: '#gridPrescTypeBar',
        enableDnd: false,
        fitColumns: false,
        rownumbers: true,
        exportXls: false,
        onClickRow: function (rowIndex, rowData) {
        },
        onDblClickRow: function (rowIndex, rowData) {
        },
        onLoadSuccess: function (data) {
        }
    };

    PHA.Grid('gridPrescType', dataGridOption);
}
function QueryPrescType(){
	var pJson = {};
	pJson.hospId = PHA_COM.Session.HOSPID;	
	pJson.locId = $('#conLoc').combobox("getValue")||"";;
	$("#gridPrescType").datagrid("query",{
		pJsonStr: JSON.stringify(pJson),
	});
}



function SavePrescType(flag){
	
	var $panel=$('#diagPrescType')
	var $grid=$('#gridPrescType')
	var title = $panel.panel('options').title;
    var ifAdd = title.indexOf('����') >= 0 ? true : false;
    
    var ptId = "";
    if (ifAdd == false) {
        var gridSelect =$grid.datagrid('getSelected');
        ptId = gridSelect.ptId || '';
    }
    var getValueArr = ['prescType', 'docLoc', 'frRangeAge', 'toRangeAge','phcPoison'];
    var valsArr = PHA.GetVals(getValueArr,"Json");
    valsArr[0]["ptId"]=ptId;
	var retJson = $.cm(
        {
            ClassName: 'PHA.COM.DataApi',
            MethodName: 'HandleInOne',
            pClassName: 'PHA.OP.PrescType.OperTab',
            pMethodName: 'SavePrescType',
            pJsonStr: JSON.stringify(valsArr)
        },false
    );
    if (retJson.success === 'N') {
	    msg=PHA_COM.DataApi.Msg(retJson)
        PHA.Alert('��ʾ', msg, 'warning');
        return false;
    }else{
		PHA.Popover({
	        msg: '����ɹ�',
	        type: 'success'
	    });
    }
    if (flag == 1) {
        PHA.ClearVals(['prescType', 'docLoc', 'frRangeAge', 'toRangeAge','phcPoison']);
        
    } else {
       $panel.dialog('close');
    }
	$grid.datagrid('reload');
}
function DelPrescType(){
	var $grid = $('#gridPrescType');
	var gridSelect = $grid.datagrid('getSelected') || '';
    if (gridSelect == '') {
        PHA.Popover({
            msg: '����ѡ����Ҫɾ������',
            type: 'alert',
            timeout: 1000
        });
        return;
    }
    var ptId = gridSelect.ptId || '';
    if(ptId==""){
		PHA.Popover({
            msg: '��¼idΪ�գ����ٴβ�ѯ��ɾ��',
            type: 'alert',
            timeout: 1000
        });
        return;
	}
	
	PHAOP_COM._Confirm("", $g("��ȷ��ɾ����ǰ����������") + "<br/>" + $g("���[ȷ��]������ɾ�������[ȡ��]������ɾ��������"), function (r) {
		if (r == true) {
		    var dataArr = [];
			var iJson = {
				ptId:ptId
			};
		    dataArr.push(iJson);
		    var retJson = $.cm(
		        {
		            ClassName: 'PHA.OP.Data.Api',
		            MethodName: 'HandleInOne',
		            pClassName: 'PHA.OP.PrescType.OperTab',
		            pMethodName: 'DelPrescType',
		            pJsonStr:JSON.stringify(dataArr)
		        },false
		    );
		    PHA.Popover({
		        msg: 'ɾ���ɹ�',
		        type: 'success'
		    });
		 	var rowIndex = $grid.datagrid('getRowIndex', gridSelect);
		   	$grid.datagrid('deleteRow', rowIndex);
   		} 
	}); 
}
function ShowDiagPrescType(btnOpt) {
	var ptId
	var ifAdd = btnOpt.id.indexOf('Add') >= 0 ? true : false;
	if(ifAdd==false){
		var $grid = $('#gridPrescType');
		var gridSelect = $grid.datagrid('getSelected') || '';
	    if (gridSelect == '') {
	        PHA.Popover({
	            msg: '����ѡ����Ҫ�޸ĵ�����',
	            type: 'alert',
	            timeout: 1000
	        });
	        return;
	    }
	    ptId = gridSelect.ptId || '';
	}
	
	$('#diagPrescType')
        .dialog({
            title: btnOpt.text,
            iconCls: ifAdd ? 'icon-w-add' : 'icon-w-edit',
            modal: true
        })
        .dialog('open');
    if (ifAdd == false) {
        $('#diagPT_btnAdd').hide();
        $.cm(
            {
                ClassName: 'PHA.OP.PrescType.Query',
                QueryName: 'GetPrescType',
                ptId: ptId,
                ResultSetType: 'Array'
            },
            function (arrData) {
                PHA.SetVals(arrData);
            }
        );
    }else{
	    var clearValueArr = ['prescType', 'docLoc', 'frRangeAge', 'toRangeAge','phcPoison'];
		PHA.ClearVals(clearValueArr);
	}
	
}

function HelpInfo(){
	$("#btnHelp").popover({
		title:'��������ά������',
		trigger:'hover',
		padding:'10px',
		width:650,
		content:'<div>'
			   +'���ƴ�����ά��ҽ�����Һ�����(����Ҳ��Ϊ��)��<br>'
			   +'<p class="pha-row">���ﴦ������ά��ҽ�����ҡ�</p >'
			   +'<p class="pha-row">�顢��һ��������ά�����Ʒ��ࡣ</p >'
			   +'<p class="pha-row">������������ά�����Ʒ��ࡣ</p >'
			   +'��ͨ�����������ڴ�ά�������������ϴ������ͼ�Ϊ��ͨ����'
			   +'</div>'
	});	
	 
}