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
		placeholder:"代码/描述/科室名/类/方法"
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
            var faceUseLocId = $(this).combobox("getValue");  //当前combobox的值
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
            title: '接口字典id',
            hidden: true,
            width: 100
        },
        {
            field: 'faceCode',
            title: '接口代码',
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
            title: '接口描述',
            width: 150,
            editor: {
	        	type: 'validatebox',
	        	options: {
	                required: true
                }
	        }
        },{
            field: 'faceUseLoc',
            title: '科室',
            descField: 'faceUseLoc',
            width: 150,
            editor: GridCmbPharmacy,
            formatter: function(value, row, index) {
                return row.faceUseLoc;
            }
        },
        {
            field: 'faceUseLocId',
            title: '科室名称',
            width: 100,
            hidden: true
       
        },
        {
            field: 'className',
            title: '接口类',
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
            title: '接口方法',
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
            title: '备注',
            width: 150,
            editor: {
	        	type: 'validatebox'
                
	        }
        },
        {
            field: 'activeFlag',
            title: '启用',
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
            title: '类方法'
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
            msg: '请先完成必填项',
            type: 'alert'
        });
        return;
    }
    var repeatObj = $grid.datagrid('checkRepeat', [['faceCode','faceUseLoc']]);
    if (typeof repeatObj.pos === 'number') {
        PHA.Popover({
            msg: '第' + (repeatObj.pos + 1) + '、' + (repeatObj.repeatPos + 1) + '行:' + repeatObj.titleArr.join('、') + '重复',
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
            msg: '没有需要保存的数据',
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
        PHA.Alert('提示', msg, 'warning');
        return;
    }else{
	    PHA.Popover({
	        msg: '保存成功',
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
            msg: '请先选中需要删除的行',
            type: 'alert',
            timeout: 1000
        });
        return;
    }
    var faceRowId = gridSelect.faceRowId || '';
    if(faceRowId!==""){
	   PHA.Popover({
	        msg: '已保存数据不能删除记录！',
	        type: 'alert',
            timeout: 1000
	    });
	    return
    }
    PHA.Popover({
        msg: '删除成功',
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
		title:'已嵌入接口',
		trigger:'hover',
		padding:'10px',
		width:650,
		content:'<div>'
			   +'<p >101--发送处方到摆药  </p >'
			   +'<p class="pha-row">110--发药机  </p >'
			   +'<p class="pha-row">102--收费后报到(查询)  </p >'
			   +'<p class="pha-row">1021--收费后报到(保存)  </p >'
			   +'<p class="pha-row">103--叫号亮灯  </p >'
			   +'<p class="pha-row">104--发药灭灯  </p >'
			   +'<p class="pha-row">105--刷卡亮灯  </p >'
			   +'<p class="pha-row">106--发药查询叫号功能  </p >'
			   +'<p class="pha-row">107--叫号上屏  </p >'
			   +'<p class="pha-row">108--发药时下屏  </p >'
			   +'<p class="pha-row">109--何时上屏  </p >'
			   +'</div>'
	});	
	 
}