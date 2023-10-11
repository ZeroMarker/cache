
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
            title: '处方类型Dr',
            hidden: true,
            width: 100
        },
        {
            field: 'preacTypeDesc',
            title: '处方类型',
            descField: 'PreacTypeDesc',
            width: 100
        },{
            field: 'docLocId',
            title: '医生科室',
            descField: 'docLocId',
            hidden: true,
            width: 150
        },{
            field: 'docLocDesc',
            title: '医生科室',
            descField: 'docLocDesc',
            width: 150
        },
        {
            field: 'rangeAge',
            title: '年龄范围(岁)',
            width: 150
        },{
            field: 'poisonDr',
            title: '管制分类id',
            descField: 'poisonDr',
            width: 150,
            hidden: true
        },
        {
            field: 'posionDesc',
            title: '管制分类',
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
    var ifAdd = title.indexOf('新增') >= 0 ? true : false;
    
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
        PHA.Alert('提示', msg, 'warning');
        return false;
    }else{
		PHA.Popover({
	        msg: '保存成功',
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
            msg: '请先选中需要删除的行',
            type: 'alert',
            timeout: 1000
        });
        return;
    }
    var ptId = gridSelect.ptId || '';
    if(ptId==""){
		PHA.Popover({
            msg: '记录id为空，请再次查询后删除',
            type: 'alert',
            timeout: 1000
        });
        return;
	}
	
	PHAOP_COM._Confirm("", $g("您确定删除当前处方类型吗") + "<br/>" + $g("点击[确定]将继续删除，点击[取消]将放弃删除操作。"), function (r) {
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
		        msg: '删除成功',
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
	            msg: '请先选中需要修改的数据',
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
		title:'处方类型维护解释',
		trigger:'hover',
		padding:'10px',
		width:650,
		content:'<div>'
			   +'儿科处方：维护医生科室和年龄(年龄也可为空)。<br>'
			   +'<p class="pha-row">急诊处方：仅维护医生科室。</p >'
			   +'<p class="pha-row">麻、精一处方：仅维护管制分类。</p >'
			   +'<p class="pha-row">精二处方：仅维护管制分类。</p >'
			   +'普通处方：不需在此维护，不符合以上处方类型即为普通处方'
			   +'</div>'
	});	
	 
}