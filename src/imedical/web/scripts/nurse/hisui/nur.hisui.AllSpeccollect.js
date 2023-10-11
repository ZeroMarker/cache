var init = function () {
	$("#Startdate,#Enddate").datebox({});
    $('#Startdate').datebox('setValue', formatDate(new Date()));
    $('#Enddate').datebox('setValue', formatDate(new Date()));
	initPatientTree();
	initBindEvent();
	
}

$(init)

function initBindEvent() {
   $('#searchBtn').bind('click', initOrdGrid);
   $('#updateBtn').bind('click', updateBtn);
   $('#ifExced').checkbox({
	    onCheckChange:function(event,value){
		    	if(value){
			    	initTempOrdGrid("true");
			    }
			    else{
				    initTempOrdGrid("false")
			    }
		    }
	    });   
}

/**
* @description 初始化患者树
*/
function initPatientTree() {
		//初始化病人树列表
		$HUI.tree('.patientTree', {
			loader: function(param, success, error) {
				$cm({
					ClassName: "Nur.NIS.Service.Base.Ward",
					MethodName: "GetWardPatients",
					wardID: session['LOGON.WARDID'],
					adm: ""
				}, function(data) {
					//添加id和text 使给vue使用的数据符合his ui tree的格式
					var addIDAndText = function(node) {
						node.id = node.ID;
						if (node.children) {
							node.text = $g(node.label);
							node.children.forEach(addIDAndText);
						}
						else{
							node.text = node.label;
						}
					}
					data.forEach(addIDAndText);
					success(data);
				});
			},
			onLoadSuccess: function() {
				initOrdGrid();
			},
			lines: true,
			checkbox: true
		});
	}

/*----------------------------------------------------------------------------------*/
/**
 * @description 初始化医嘱列表
 */
 
 function initOrdGrid() {
 	var IfExced = $('#ifExced').checkbox('getValue');
 	initTempOrdGrid(IfExced);
 }
 
function initTempOrdGrid(IfExced) {
  var innerHeight=window.innerHeight;
  $('#summaryDrugGrid').datagrid({
    url: $URL,
    height:innerHeight-107,
    queryParams: {
      ClassName: "Nur.HISUI.SpecManage",
      QueryName: "getAllSpeccollectOrd",
      ResultSetType: 'array',
      EpisodeIDStr: EpisodeIDStr,
      IfUpdate: IfExced,
      LogonWard:session['LOGON.WARDID'],
      sttDate:$("#Startdate").datebox("getValue"),
      endDate:$("#Enddate").datebox("getValue")
    },
    columns: [[
      { field: 'check', title: '选择', checkbox: true, width: 30 },
      { field: 'PatName', title: '姓名', width: 100 },
      { field: 'BedCode', title: '床号', width: 50 },
      { field: 'MedCareNo', title: '住院号', width: 100 },
      { field: 'Age', title: '年龄', width: 70 },
      { field: 'ArcimDesc', title: '医嘱名称', width: 300 },
      { field: 'OrderStatu', title: '医嘱状态', width: 80 },
      { field: 'labNo', title: '标本号', width: 100, },
      { field: 'CollDateTime', title: '采血时间', width: 120},
      { field: 'OrderID', title: '医嘱ID', width: 100}
    ]],
    rownumbers: true, //如果为true, 则显示一个行号列
    idField: 'labNo',
    selectOnCheck:false, 
    checkOnSelect:false,
    singleSelect:true, 
    onBeforeLoad:function(param){
	    $('#summaryDrugGrid').datagrid("unselectAll");
	}
  });
}

/**
 * @description 更新按钮监听
 */
function updateBtn() {
	var IfExced = $('#ifExced').checkbox('getValue');
    var selectArray = $('#summaryDrugGrid').datagrid('getChecked');
    var ordIdArray = selectArray.map(function (row) {
        return row.labNo
    })
    if(ordIdArray.length>0){
    	var ordIds = ordIdArray.join('^');
    	if (IfExced){
	    	$.messager.confirm('确认对话框', '已经更新过采血时间是否再次更新？', function(r){
				if (r){
				    updateOrd(ordIds);
				}
			});
    	}else{
	    	updateOrd(ordIds);	
	    }
    }else{
	    $.messager.popover({ msg: '请选择医嘱!', type: 'error'});
	}
}

function updateOrd(ordIds) {
	var IfExced = $('#ifExced').checkbox('getValue');
	var errInfo = "";
	
	var errInfo = tkMakeServerCall("Nur.HISUI.SpecManage","AllUpdateCollDateTime",ordIds,session['LOGON.USERID'],session['LOGON.WARDID'],"");
	if (errInfo == "") {
		$.messager.popover({ msg: '更新成功!', type: 'success'}); 
		initTempOrdGrid(IfExced);
	} else {
		$.messager.popover({ msg: errInfo , type: 'error'});	
	}
}