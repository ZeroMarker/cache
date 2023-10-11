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
* @description ��ʼ��������
*/
function initPatientTree() {
		//��ʼ���������б�
		$HUI.tree('.patientTree', {
			loader: function(param, success, error) {
				$cm({
					ClassName: "Nur.NIS.Service.Base.Ward",
					MethodName: "GetWardPatients",
					wardID: session['LOGON.WARDID'],
					adm: ""
				}, function(data) {
					//���id��text ʹ��vueʹ�õ����ݷ���his ui tree�ĸ�ʽ
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
 * @description ��ʼ��ҽ���б�
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
      { field: 'check', title: 'ѡ��', checkbox: true, width: 30 },
      { field: 'PatName', title: '����', width: 100 },
      { field: 'BedCode', title: '����', width: 50 },
      { field: 'MedCareNo', title: 'סԺ��', width: 100 },
      { field: 'Age', title: '����', width: 70 },
      { field: 'ArcimDesc', title: 'ҽ������', width: 300 },
      { field: 'OrderStatu', title: 'ҽ��״̬', width: 80 },
      { field: 'labNo', title: '�걾��', width: 100, },
      { field: 'CollDateTime', title: '��Ѫʱ��', width: 120},
      { field: 'OrderID', title: 'ҽ��ID', width: 100}
    ]],
    rownumbers: true, //���Ϊtrue, ����ʾһ���к���
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
 * @description ���°�ť����
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
	    	$.messager.confirm('ȷ�϶Ի���', '�Ѿ����¹���Ѫʱ���Ƿ��ٴθ��£�', function(r){
				if (r){
				    updateOrd(ordIds);
				}
			});
    	}else{
	    	updateOrd(ordIds);	
	    }
    }else{
	    $.messager.popover({ msg: '��ѡ��ҽ��!', type: 'error'});
	}
}

function updateOrd(ordIds) {
	var IfExced = $('#ifExced').checkbox('getValue');
	var errInfo = "";
	
	var errInfo = tkMakeServerCall("Nur.HISUI.SpecManage","AllUpdateCollDateTime",ordIds,session['LOGON.USERID'],session['LOGON.WARDID'],"");
	if (errInfo == "") {
		$.messager.popover({ msg: '���³ɹ�!', type: 'success'}); 
		initTempOrdGrid(IfExced);
	} else {
		$.messager.popover({ msg: errInfo , type: 'error'});	
	}
}