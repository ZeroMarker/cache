/*
 * FileName:	dhcbill.pkg.nodiscountsconfig.js
 * User:		WangRan
 * Date:		2019-10-14
 * Function:	�ۿ���ά��
 * Description: 
*/
var EditRowIndex=undefined;
var LocRowIndex=-1;
var LocRecRowIndex=-1;
var PkgGrpL;
var UserDR=session['LOGON.USERID'];
//var HospDr=session['LOGON.HOSPID'];
var GroupDr=session['LOGON.GROUPID'];
 $(function () {

	InittSign();//ҽ������
	initPkgGrpList();//�б�
	initPkgListMenu(); //��ɾ��
	
	
});
function getNowDateTime(){  //��ȡ��������ʱ��
	var date = new Date();
	var year = date.getFullYear();
	var month = date.getMonth()+1;
	var day = date.getDate();
	var hour=date.getHours();
    var minute=date.getMinutes();
    var second=date.getSeconds();
    if (hour<10) {
            	hour='0'+hour;
            }
            if (minute<10) {
            	minute='0'+minute;
            }
            if (second<10) {
            	second='0'+second;
            }
	if (month < 10) {
	month = "0" + month;
	}
	if (day < 10) {
	day = "0" + day;
	}
	NowTime=hour+":"+minute+":"+second;
    NowDate = year+"-"+month+"-"+day;
}


function InittSign() {
	/*
    $HUI.combobox("#tSign", {	//��Ч��ʶ
        valueField: 'label',
        textField: 'value',
        panelHeight:80,
        limitToList:true,
        data: [
            {
                value: '��Ч',
                label: '1',
            },
            {
                value: '��Ч',
                label: '0',
            }
        ],
        onSelect:function(data){
			//setValueById('tTOrdCat',data.Id);
			alert("99")
			if(data.Id==0){
				setValueById('tTOrdCat',"");
			}
			InitOrdCatSub();//ҽ������
			InitItmMast();//ҽ����  
			//alert(getValueById('tTOrdCat'))
		}	
    }
    
    )*/
    
    PKGLoadDicData('tSign','DiscStus',"","")
}
 
function initPkgListMenu() {
	//����
	$HUI.linkbutton('#BtnAdd', {
		onClick: function () {
			$('#BtnAdd').linkbutton('disable');
			//$('#BtnUpdate').linkbutton('disable');
			addClick();
			$('#BtnSave').linkbutton('enable');
			
		}
	});
	//��ѯ
	$HUI.linkbutton('#BtnFind', {
		onClick: function () {
	
			var TOrdCatSub=getValueById('tTOrdCatSub');
			if(typeof(TOrdCatSub)=="undefined"){
				setValueById('tTOrdCatSub',"")
			}
			initPkgGrpList();
		}
	});
	
	//����
	$HUI.linkbutton('#BtnSave', {
		onClick: function () {
			saveClick();

		}
	});
	//�޸�
	$HUI.linkbutton('#BtnUpdate', {
		onClick: function () {
			//$('#BtnAdd').linkbutton('disable');
			$('#BtnUpdate').linkbutton('disable');
			updateClick();
			$('#BtnSave').linkbutton('enable');
		}
	});
	//����
	$('#BtnClear').bind('click', function () {
	window.location.reload(true);	
});
}	

function updateClick() {  //�޸�
	var row = PkgGrpL.getSelected();//ѡ���ж���
	EditRowIndex =PkgGrpL.getRowIndex(row);//��ǰ���к�
	//PkgGrpL.selectRow(EditRowIndex);//ѡ����
	PkgGrpL.beginEdit(EditRowIndex);//�༭��
}

function addClick() { //����
	var row = {};
	var val = "";
	$.each(PkgGrpL.getColumnFields(), function (index, item) {
		val = "";
		row[item] = val;
	});
	if (endEditing()) {
		PkgGrpL.appendRow(row);
		EditRowIndex = PkgGrpL.getRows().length - 1;
		
		PkgGrpL.selectRow(EditRowIndex);
		PkgGrpL.beginEdit(EditRowIndex);
	
	}
}


function saveClick(){               //����
	//var rtn = tkMakeServerCall("web.DHCOPBillChargExcepiton", "GetOrdStatus", PrtRowID);
	//w ##class(BILL.PKG.BL.DiscountRate).Save("^����^����^0.2^^^^^2^^0^2^2019-10-17^")
	PkgGrpL.endEdit(EditRowIndex);
	PkgGrpL.acceptChanges();
	var row = PkgGrpL.getSelected();
	if(row.Code==""){
		$.messager.alert('��ʾ', "����ʧ�� : ���벻��Ϊ�գ�");
	$('#BtnSave').linkbutton('disable');
	$('#BtnAdd').linkbutton('enable');
	$('#BtnUpdate').linkbutton('enable');
	initPkgGrpList();
	
	EditRowIndex = undefined;
		return false;
	}
	if(row.Desc==""){
		$.messager.alert('��ʾ', "����ʧ�� : ��������Ϊ�գ�");
	$('#BtnSave').linkbutton('disable');
	$('#BtnAdd').linkbutton('enable');
	$('#BtnUpdate').linkbutton('enable');
	initPkgGrpList();
	
	EditRowIndex = undefined;
		return false;
	}
	if(row.DiscountRate==""){
			$.messager.alert('��ʾ', "����ʧ�� : �ۿ��ʲ���Ϊ�գ�");
	$('#BtnSave').linkbutton('disable');
	$('#BtnAdd').linkbutton('enable');
	$('#BtnUpdate').linkbutton('enable');
	initPkgGrpList();
	
	EditRowIndex = undefined;
		return false;
	}
	if((row.DiscountRate<=0)||(row.DiscountRate>=1)){
			$.messager.alert('��ʾ', "����ʧ�� : �ۿ���ֻ�ܴ���0С��1��");
	$('#BtnSave').linkbutton('disable');
	$('#BtnAdd').linkbutton('enable');
	$('#BtnUpdate').linkbutton('enable');
	initPkgGrpList();
	
	EditRowIndex = undefined;
		return false;
	}
	
	var Id=row.Id
	var CreatUser=""
	var UpUser=""
	if(Id==""){
		CreatUser=UserDR
	}else{
		CreatUser=row.CreatUserDr
		UpUser=UserDR
	}
	var Code=row.Code
	var Desc=row.Desc
	var DiscountRate=row.DiscountRate
	var ActiveStatus=row.ActiveStatus
	if(ActiveStatus==""){
		ActiveStatus=1
	}
	var DISCRStDate=row.DISCRStDate
	var DISCREndDate=row.DISCREndDate
	var StringData=Id+"^"+Code+"^"+Desc+"^"+DiscountRate+"^^^^^"+CreatUser+"^"+UpUser+"^"+ActiveStatus+"^"+PUBLIC_CONSTANT.SESSION.HOSPID+"^"+DISCRStDate+"^"+DISCREndDate
		var rtn = tkMakeServerCall("BILL.PKG.BL.DiscountRate", "Save", StringData);
		if(rtn>=0){
			$.messager.alert('��ʾ', "����ɹ�", 'success');
		}
		else{alert(rtn)}
   		

	$('#BtnSave').linkbutton('disable');
	$('#BtnAdd').linkbutton('enable');
	$('#BtnUpdate').linkbutton('enable');
	initPkgGrpList();
	
	EditRowIndex = undefined;
	
	
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


	
	
function onBeginEditHandler(index, row) {
	var ed = PkgGrpL.getEditor({index: index, field: "TarcatDesc"});
	if (ed) {
		//$(ed.target).next("span").find("input").focus();
	}
}

function onEndEditHandler(index, row) {
	var ed = PkgGrpL.getEditor({index: index, field: "TarcatDesc"});
	if (ed) {
		//row.OPOrdItemDesc = $(ed.target).combogrid("getText");
	}

	//PkgGrpL.checkRow(index);
}


function onDblClickRowHandler(index, row) {

	if (EditRowIndex != index) {
		if (endEditing()) {
			beginEditing(index);
			EditRowIndex = index;
		} else {
			setTimeout(function() {
				PkgGrpL.selectRow(EditRowIndex);
			}, 0);
		}
	}
}




/*
	�б�
*/
//(ind,Id,Code,Desc,DiscountRate,ActiveStatus,CreatDate,CreatTime,UpdateDate,UpdateTime,CreatUserDr,CreatUser,UpdateUserDr,UpdateUser,HospitalDr,Hospital,DISCRStDate,DISCREndDate)

function initPkgGrpList() { //(OrdCatDr As %String = "", OrdCatSubDr As %String = "", ArcKeyWords As %String = "", HospDr As %String = "")
	 var loadSuccess = false;
	PkgGrpL= $HUI.datagrid("#dg", {
		url:$URL + "?ClassName=BILL.PKG.BL.DiscountRate&QueryName=QueryDiscountRate&KeyWords="+encodeURI(getValueById('tCode')) +"&ActStatus="+getValueById('tSign')+"&HospDr="+PUBLIC_CONSTANT.SESSION.HOSPID,

		fit: true,
		striped: true,
		iconCls: 'icon-paper',
		headerCls: 'panel-header-gray',
		singleSelect: true,
		rownumbers: false,
		border:false,
		pageSize: 10,
		pagination:true,
		toolbar: '#tToolBar',
		columns: [[ 
					{ field: 'Code', title: '����', width: 120, align: 'center', editor : 'text', sortable: true, resizable: true },
					{ field: 'Desc', title: '����', width: 120, align: 'center', editor : 'text', sortable: true, resizable: true },
					{ field: 'DiscountRate', title: '�ۿ���', width: 80, align: 'center', editor : 'text', sortable: true, resizable: true },
					{ field: 'ActiveStatus', title: '��Ч��־', width: 100, align: 'center',
					formatter:function(value,data,row){
					    value=='1'?value='��Ч':value='��Ч';
					    return value;
					    },
				    editor:{
					type: 'combobox',
					options: {
						panelHeight: 'auto',
						panelHeight:80,
						valueField: 'Code',
						textField: 'Desc',
						limitToList: true,
						data:[
							{"Code":"1","Desc":"��Ч"},
							{"Code":"0","Desc":"��Ч"}
						],
												
						onChange: function(newValue, oldValue) {
							
						}
					}
		
				}
			},
					{ field: 'DISCRStDate', title: '��ʼ����', width: 120, align: 'center', editor : 'datebox',sortable: true, resizable: true },
					{ field: 'DISCREndDate', title: '��������', width: 120, align: 'center', editor : 'datebox',sortable: true, resizable: true },
					{ field: 'CreatDate', title: '��������', width: 100, align: 'center', sortable: true, resizable: true },
					{ field: 'CreatTime', title: '����ʱ��', width: 100, align: 'center', sortable: true, resizable: true },
					{ field: 'CreatUser', title: '������', width: 100, align: 'center', sortable: true, resizable: true },
					{ field: 'UpdateDate', title: '�޸�����', width: 100, align: 'center', sortable: true, resizable: true },
					{ field: 'UpdateTime', title: '�޸�ʱ��', width: 100, align: 'center', sortable: true, resizable: true },
					{ field: 'UpdateUser', title: '�޸���', width: 100, align: 'center', sortable: true, resizable: true },
					{ field: 'Hospital', title: 'Ժ��', width: 200, align: 'center', sortable: true, resizable: true},
					{ field: 'HospitalDr', title: 'Ժ��ID', width: 50, align: 'center', sortable: true, resizable: true, hidden: true },
					{ field: 'CreatUserDr', title: '�����ID', width: 50, align: 'center', sortable: true, resizable: true, hidden: true },
					{ field: 'UpdateUserDr', title: '�޸���ID', width: 50, align: 'center', sortable: true, resizable: true, hidden: true },
					{ field: 'Id', title: 'rowidID', width: 50, align: 'center', sortable: true, resizable: true, hidden: true },
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
			onBeginEditHandler(index, row);
    	},
		onDblClickRow: function(index, row) {
			onDblClickRowHandler(index, row);
		},
		onEndEdit: function(index, row, changes) {
			onEndEditHandler(index, row);
		}
	});
	//GV.OEItmList.loadData({"rows": [], "total": 0});
}


// Ժ��combogridѡ���¼�
function selectHospCombHandle(){

    InittSign();//ҽ������
	initPkgGrpList();//�б�
	initPkgListMenu(); //��ɾ��
}