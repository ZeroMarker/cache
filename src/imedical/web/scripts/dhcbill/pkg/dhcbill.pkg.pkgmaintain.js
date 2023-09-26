/*
 * FileName:	dhcbill.pkg.pkgmaintain.js
 * User:		LiuBingkai
 * Date:		2019-09-18
 * Function:	
 * Description: �ײ���ά��
 */
 
/*todo
��������Ϊ��ʱ���ܱ���
�������ӡ���ť���ܼ������
�����
*/ 



//var HospDr = session['LOGON.HOSPID'];
var GUser = session['LOGON.USERID'];
var EditRowIndex = undefined;
var LocRowIndex = -1;
var LocRecRowIndex = -1;
var PkgGrpL;
//���������Ҫ������
var NowDate;
var NowTime;
var updFlag = "";
var rowindex = "";
var Code = "";
var Desc = "";
var KeyWords="";
var ActiveStatus = "";
var CreateDate = "";
var CreateTime = "";
var UpdateDate = "";
var UpdateTime = "";
var CreateUserDr = "";
var UpdateUserDr = "";
var Mark = "";
var Rowid = "";
//"^"+row.Code+"^"+row.Desc+"^"+row.ActiveStatus+"^"+NowDate+"^"+NowTime+"^"+""+"^"+""+"^"+GUser+"^"+""+"^"+row.Mark+"^"+HospDr

$(function () {
	//key_enter();
	initPkgGrpList(KeyWords,ActiveStatus);	//�б�
	initPkgListMenu(); 	//��ɾ�Ĳ�
	activeStatus();		//��Ч��ʶ
	initKeyWords();		//�ؼ���
	
});

//�ؼ���  
function initKeyWords() {
	$HUI.combobox("#KeyWords",{		  
		valueField:'Code', 
		textField:'Desc',
		mode: 'remote',
		url:$URL,
		filter:function(Alias,row){},
		onBeforeLoad:function(param){
				param.ClassName = "BILL.PKG.BL.PackageGroup";
				param.QueryName = "QueryPackageGroup";
				param.KeyWords=param.q;
				param.HospDr=PUBLIC_CONSTANT.SESSION.HOSPID;
				
				param.ResultSetType='Array';
		},	
		onLoadSuccess:function(){
			//alert(getValueById('tTOrdCat'))
			//setValueById('tTItmMast',data);
			//alert(getValueById('tTOrdCatSub'))
		},
		onLoadError:function(err){
			
		},
		onChange:function(oldVal,newVal){
			
			//tTItmMas=newVal
		},
		onSelect:function(data){
			//setValueById('tTItmMast',data.ArcimRowID);
			
		}	
	})	
}

function activeStatus() {
    $HUI.combobox("#ValidMark", {	//��Ч��ʶ
        valueField: 'label',
        textField: 'value',
        data: [
            {
                value: '��Ч',
                label: '1',
            },
            {
                value: '��Ч',
                label: '0',
            }
        ]
    })
}
 
function initPkgListMenu() {
	//����
	$HUI.linkbutton('#BtnAdd', {
		onClick: function () {
			addClick();
		}
	});
	
	//����
	$('#BtnClear').bind('click', function () {
		window.location.reload(true);
	})
	
	//����
	$HUI.linkbutton('#BtnSave', {
		onClick: function () {
			saveClick();
		}
	});
	
	//��ѯ
	$HUI.linkbutton('#BtnFind', {
		onClick: function () {
			findClick();
		}
	});
	
	
	//�޸�
	$HUI.linkbutton('#BtnUpdate', {
		onClick: function () {
			updClick();
		}
	});
	
}	

function addClick() {
	//������ʱ�����������޸İ�ť
	$('#BtnAdd').linkbutton('disable');
	//$('#BtnUpdate').linkbutton('disable');
	updFlag = 0;
	$HUI.datagrid("#dg","clearChecked");
	$HUI.datagrid("#dg","clearSelections");
	appendEditRow();
	
}

function appendEditRow() {
	var row = {};
	var val = "";
	/*$.each(PkgGrpL.getColumnFields(), function (index, item) {
		val = "";
		row[item] = val;
	});*/
	if (endEditing()) {
		PkgGrpL.appendRow(row);
		EditRowIndex = PkgGrpL.getRows().length - 1;
		beginEditing(EditRowIndex);
	}
}

function endEditing() {
	if (EditRowIndex == undefined) {
		return true;
	}
	if (validateRow(EditRowIndex)) {
		PkgGrpL.endEdit(EditRowIndex);
		EditRowIndex = undefined;
		return true;
	} else {
		return false;
	}
}
function validateRow(index) {
	var row = PkgGrpL.getRows()[index];
	if (!row) {
		return false;
	}
	/*if (!row.OPOrdItemRowID) {
		return true;
	}
	if (!row.OPOrdQty || !row.OPOrdItemRecLocRID) {
		return false;
	}*/
	return checkAddData(row);
}

function checkAddData(row) {
	return true;
}


function beginEditing(index) {
	PkgGrpL.selectRow(index);
	PkgGrpL.beginEdit(index);
	/*
	var row = PkgGrpL.getRows()[index];
	if (row) {
		var ed = PkgGrpL.getEditor({index: index, field: "PkgG1"});
		if (ed) {
			//$(ed.target).prop("disabled", true);
		}
	};*/
}

/*
function SelectRowHandler(index,rowData)
{
	var value = getValueById('Desc', rowData.Desc);
	//$('#').click();d ##class(%ResultSet).RunQuery("BILL.PKG.BL.Product","QueryProduct","","","","")
	alert(value);
}*/	


function saveClick() {	//InStr:��ʽ��Rowid^����^����^��Ч��־(1:��Ч,0:��Ч)^��������^����ʱ��^�޸�����^�޸�ʱ��^������^�޸���^��ע^ҽԺID
	//alert(EditRowIndex);
	if(updFlag === "") {return false;}
	PkgGrpL.endEdit(EditRowIndex);
	PkgGrpL.acceptChanges();

	
	var row = PkgGrpL.getSelected();
	/*if(row.Code==""||row.Desc==""||row.ActiveStatus==""){
		$.messager.alert('��ʾ', "����ʧ�� : �����������Ϣ��");
		initPkgGrpList(KeyWords,ActiveStatus);
		$('#BtnAdd').linkbutton('enable');
	    $('#BtnUpdate').linkbutton('enable');
		EditRowIndex=undefined;
		return false;
		}*/
	if(row.Code==""){
		$.messager.alert('��ʾ', "����ʧ�� : ���벻��Ϊ�գ�");
		initPkgGrpList(KeyWords,ActiveStatus);
		$('#BtnAdd').linkbutton('enable');
	    $('#BtnUpdate').linkbutton('enable');
		EditRowIndex=undefined;
		return false;
		} 	
	if(row.Desc==""){
		$.messager.alert('��ʾ', "����ʧ�� : ��������Ϊ�գ�");
		initPkgGrpList(KeyWords,ActiveStatus);
		$('#BtnAdd').linkbutton('enable');
	    $('#BtnUpdate').linkbutton('enable');
		EditRowIndex=undefined;
		return false;
		}
	if(row.ActiveStatus==""){
		$.messager.alert('��ʾ', "����ʧ�� : ��Ч��־����Ϊ�գ�");
		initPkgGrpList(KeyWords,ActiveStatus);
		$('#BtnAdd').linkbutton('enable');
	    $('#BtnUpdate').linkbutton('enable');
		EditRowIndex=undefined;
		return false;
		}	
	Code = row.Code;
	Desc = row.Desc;
	ActiveStatus = row.ActiveStatus;
	Mark = row.Mark;
	//Rowid = row.Id;
	//CreateDate = row.CreatDate;
	//CreateTime = row.CreatTime;
	CreateUserDr = row.CreatUserDr;
	//alert(Rowid)
	if (updFlag  == 0) {
		//getNowDateTime();
		Rowid = "";
	    CreateDate = "";
		CreateTime = "";
		CreateUserDr = GUser;
    } else {
	    //getNowDateTime();
	    Rowid = row.Id;
	    CreateDate = row.CreatDate;
		CreateTime = row.CreatTime;
		CreateUserDr = row.CreatUserDr;
    	//UpdateDate = NowDate;
    	//UpdateTime = NowTime;
    	UpdateUserDr = GUser;
    }
    //alert(CreateUserDr + "!" + UpdateUserDr);
	//alert(CreateTime + "!" + UpdateTime)
	//alert(CreateUserDr)
	var inStr = Rowid+"^"+Code+"^"+Desc+"^"+ActiveStatus+"^"+CreateDate+"^"+CreateTime+"^"+UpdateDate+"^"+UpdateTime+"^"+CreateUserDr+"^"+UpdateUserDr+"^"+Mark+"^"+PUBLIC_CONSTANT.SESSION.HOSPID
    //alert(inStr)
	//EditRowIndex = PkgGrpL.getRows().length - 1;
	//alert(EditRowIndex);
	if (EditRowIndex != -1) {
		//var inStr = row.CreatDate;
		//var inStr = inStr + "^" + getValueById('Desc');	
		//alert(inStr);
	}
	
	//setValueById("KeyWords", row.Desc);
	var rtn = tkMakeServerCall("BILL.PKG.BL.PackageGroup", "Save", inStr);
	initPkgGrpList(row.Code,ActiveStatus);
	EditRowIndex=undefined;
	UpdateUserDr=""
	updFlag="";
	ActiveStatus = ""
	$('#BtnAdd').linkbutton('enable');
	$('#BtnUpdate').linkbutton('enable');
	$.messager.alert('��ʾ', "����ɹ�", 'success');
	
	initPkgGrpList('','');
	
}

function updClick() {
	//alert("1111")
	//EditRowIndex = PkgGrpL.getRows().length - 1;
	//$('#BtnAdd').linkbutton('disable');
	$('#BtnUpdate').linkbutton('disable');
	updFlag = 1;
	//�޸�ʱ��ֹ�޸��ײ������
	var e = PkgGrpL.getColumnOption('Code');
	e.editor = {};
	EditRowIndex = rowindex;
	PkgGrpL.selectRow(EditRowIndex);
	PkgGrpL.beginEdit(EditRowIndex);
}


function findClick() {
	initPkgGrpList(KeyWords,ActiveStatus);
}


/*
	�б�
*/


function initPkgGrpList(KeyWords,ActiveStatus) {
	if (KeyWords == "") {
		KeyWords = getValueById("KeyWords");
	}
	if (ActiveStatus == "") {
		ActiveStatus = getValueById("ValidMark");
	}
	var loadSuccess = false;
	PkgGrpL= $HUI.datagrid("#dg", {
		url:$URL + "?ClassName=BILL.PKG.BL.PackageGroup&QueryName=QueryPackageGroup&KeyWords="+KeyWords+"&ActStatus="+ActiveStatus+"&HospDr="+PUBLIC_CONSTANT.SESSION.HOSPID,
		fit: true,
		striped: true,
		border:false ,
		//title: '�ײ����б�',
		iconCls: 'icon-paper',
		headerCls: 'panel-header-gray',
		singleSelect: true,
		rownumbers: false,
		pageSize: 20,
		pagination:true,
		toolbar: '#tToolBar',
		onClickRow:function(rowIndex, rowData){
			    	rowindex=rowIndex;
										
				},
		columns: [[ 
			{ field: 'Id', title: '', width: 200, align: 'center', hidden: true,},
			{ field: 'Code', title: '����', width: 100, align: 'center',
				editor:{
			        type: 'text',
			        options: {
						 	//isKeyupChange: true,
						 	onChange: function(newValue, oldValue) {
							//Code=newValue;
							 
							}
					}
			    }
			},
			{ field: 'Desc', title: '����', width: 200, align: 'center',
				editor:{
			        type: 'text',
			        options: {
						 	isKeyupChange: true,
						 	onChange: function(newValue, oldValue) {
							 
							}
					}
			    }
			},
			{ field: 'ActiveStatus', title: '��Ч��־', width: 100, align: 'center',
				formatter:function(value,row,index){
					value=='1'?value='��Ч':value='��Ч';
					return value;
					},
				
				editor:{
					type: 'combobox',
					options: {
						panelHeight: 'auto',
						valueField: 'Code',
						textField: 'Desc',
						data:[
							{"Code":"1","Desc":"��Ч"},
							{"Code":"0","Desc":"��Ч"}
						],
							
						onChange: function(newValue, oldValue) {
							
						}
					}
		
				}
			},
			{ field: 'Mark', title: '��ע', width: 200, align: 'center',
				editor:{
			        type: 'text',
			        options: {
						 	isKeyupChange: true,
						 	onChange: function(newValue, oldValue) {
							 
							}
					}
			    }
			},
			{ field: 'Hospital', title: 'Ժ��', width: 200, align: 'center',},
			{ field: 'CreatUser', title: '������', width: 100, align: 'center',},
			{ field: 'CreatUserDr', title: '������Dr', width: 100, align: 'center', hidden: true,},
			{ field: 'CreatDate', title: '��������', width: 100, align: 'center',},
			{ field: 'CreatTime', title: '����ʱ��', width: 100, align: 'center',},
			{ field: 'UpdateUser', title: '�޸���', width: 100, align: 'center',},
			{ field: 'UpdateUserDr', title: '�޸���Dr', width: 100, align: 'center', hidden: true,},
			{ field: 'UpdateDate', title: '�޸�����', width: 100, align: 'center',},
			{ field: 'UpdateTime', title: '�޸�ʱ��', width: 100, align: 'center',}
		]],
		data:[],					
		onLoadSuccess: function (data) {
		
		},
		rowStyler: function(index, row) {
		
		},
		onCheck: function (rowIndex, rowData) {
			//spliceUnBillOrder(rowData.OrdRowId);
			if (!loadSuccess) {
				return;
			}
		
		},
		onUncheck: function (rowIndex, rowData) {
			
		},
		onBeginEdit: function(index, row) {
			/*if(updFlag){
				onBeginEditHandler(index, row);
				}else{
					onBeginEditHandler1(index, row);
					}*/
			
    	},
		//onDblClickRow: function(index, row) {
			//onDblClickRowHandler(index, row);
	//	},
		onEndEdit: function(index, row, changes) {
			//onEndEditHandler(index, row);
		}
	});
	//GV.OEItmList.loadData({"rows": [], "total": 0});
}



// Ժ��combogridѡ���¼�
function selectHospCombHandle(){
	initKeyWords();		//�ؼ���
	activeStatus();		//��Ч��ʶ
	initPkgGrpList(KeyWords,ActiveStatus);

}