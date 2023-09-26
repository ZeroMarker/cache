/*
 * FileName:	dhcbill.pkg.nodiscountsconfig.js
 * User:		WangRan
 * Date:		2019-10-14
 * Function:	折扣率维护
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

	InittSign();//医嘱大类
	initPkgGrpList();//列表
	initPkgListMenu(); //增删改
	
	
});
function getNowDateTime(){  //获取现在日期时间
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
    $HUI.combobox("#tSign", {	//有效标识
        valueField: 'label',
        textField: 'value',
        panelHeight:80,
        limitToList:true,
        data: [
            {
                value: '有效',
                label: '1',
            },
            {
                value: '无效',
                label: '0',
            }
        ],
        onSelect:function(data){
			//setValueById('tTOrdCat',data.Id);
			alert("99")
			if(data.Id==0){
				setValueById('tTOrdCat',"");
			}
			InitOrdCatSub();//医嘱子类
			InitItmMast();//医嘱项  
			//alert(getValueById('tTOrdCat'))
		}	
    }
    
    )*/
    
    PKGLoadDicData('tSign','DiscStus',"","")
}
 
function initPkgListMenu() {
	//新增
	$HUI.linkbutton('#BtnAdd', {
		onClick: function () {
			$('#BtnAdd').linkbutton('disable');
			//$('#BtnUpdate').linkbutton('disable');
			addClick();
			$('#BtnSave').linkbutton('enable');
			
		}
	});
	//查询
	$HUI.linkbutton('#BtnFind', {
		onClick: function () {
	
			var TOrdCatSub=getValueById('tTOrdCatSub');
			if(typeof(TOrdCatSub)=="undefined"){
				setValueById('tTOrdCatSub',"")
			}
			initPkgGrpList();
		}
	});
	
	//保存
	$HUI.linkbutton('#BtnSave', {
		onClick: function () {
			saveClick();

		}
	});
	//修改
	$HUI.linkbutton('#BtnUpdate', {
		onClick: function () {
			//$('#BtnAdd').linkbutton('disable');
			$('#BtnUpdate').linkbutton('disable');
			updateClick();
			$('#BtnSave').linkbutton('enable');
		}
	});
	//清屏
	$('#BtnClear').bind('click', function () {
	window.location.reload(true);	
});
}	

function updateClick() {  //修改
	var row = PkgGrpL.getSelected();//选中行对象
	EditRowIndex =PkgGrpL.getRowIndex(row);//当前行行号
	//PkgGrpL.selectRow(EditRowIndex);//选择行
	PkgGrpL.beginEdit(EditRowIndex);//编辑行
}

function addClick() { //增加
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


function saveClick(){               //保存
	//var rtn = tkMakeServerCall("web.DHCOPBillChargExcepiton", "GetOrdStatus", PrtRowID);
	//w ##class(BILL.PKG.BL.DiscountRate).Save("^编码^描述^0.2^^^^^2^^0^2^2019-10-17^")
	PkgGrpL.endEdit(EditRowIndex);
	PkgGrpL.acceptChanges();
	var row = PkgGrpL.getSelected();
	if(row.Code==""){
		$.messager.alert('提示', "保存失败 : 代码不能为空！");
	$('#BtnSave').linkbutton('disable');
	$('#BtnAdd').linkbutton('enable');
	$('#BtnUpdate').linkbutton('enable');
	initPkgGrpList();
	
	EditRowIndex = undefined;
		return false;
	}
	if(row.Desc==""){
		$.messager.alert('提示', "保存失败 : 描述不能为空！");
	$('#BtnSave').linkbutton('disable');
	$('#BtnAdd').linkbutton('enable');
	$('#BtnUpdate').linkbutton('enable');
	initPkgGrpList();
	
	EditRowIndex = undefined;
		return false;
	}
	if(row.DiscountRate==""){
			$.messager.alert('提示', "保存失败 : 折扣率不能为空！");
	$('#BtnSave').linkbutton('disable');
	$('#BtnAdd').linkbutton('enable');
	$('#BtnUpdate').linkbutton('enable');
	initPkgGrpList();
	
	EditRowIndex = undefined;
		return false;
	}
	if((row.DiscountRate<=0)||(row.DiscountRate>=1)){
			$.messager.alert('提示', "保存失败 : 折扣率只能大于0小于1！");
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
			$.messager.alert('提示', "保存成功", 'success');
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
	列表
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
					{ field: 'Code', title: '代码', width: 120, align: 'center', editor : 'text', sortable: true, resizable: true },
					{ field: 'Desc', title: '描述', width: 120, align: 'center', editor : 'text', sortable: true, resizable: true },
					{ field: 'DiscountRate', title: '折扣率', width: 80, align: 'center', editor : 'text', sortable: true, resizable: true },
					{ field: 'ActiveStatus', title: '有效标志', width: 100, align: 'center',
					formatter:function(value,data,row){
					    value=='1'?value='有效':value='无效';
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
							{"Code":"1","Desc":"有效"},
							{"Code":"0","Desc":"无效"}
						],
												
						onChange: function(newValue, oldValue) {
							
						}
					}
		
				}
			},
					{ field: 'DISCRStDate', title: '开始日期', width: 120, align: 'center', editor : 'datebox',sortable: true, resizable: true },
					{ field: 'DISCREndDate', title: '结束日期', width: 120, align: 'center', editor : 'datebox',sortable: true, resizable: true },
					{ field: 'CreatDate', title: '创建日期', width: 100, align: 'center', sortable: true, resizable: true },
					{ field: 'CreatTime', title: '创建时间', width: 100, align: 'center', sortable: true, resizable: true },
					{ field: 'CreatUser', title: '创建人', width: 100, align: 'center', sortable: true, resizable: true },
					{ field: 'UpdateDate', title: '修改日期', width: 100, align: 'center', sortable: true, resizable: true },
					{ field: 'UpdateTime', title: '修改时间', width: 100, align: 'center', sortable: true, resizable: true },
					{ field: 'UpdateUser', title: '修改人', width: 100, align: 'center', sortable: true, resizable: true },
					{ field: 'Hospital', title: '院区', width: 200, align: 'center', sortable: true, resizable: true},
					{ field: 'HospitalDr', title: '院区ID', width: 50, align: 'center', sortable: true, resizable: true, hidden: true },
					{ field: 'CreatUserDr', title: '添加人ID', width: 50, align: 'center', sortable: true, resizable: true, hidden: true },
					{ field: 'UpdateUserDr', title: '修改人ID', width: 50, align: 'center', sortable: true, resizable: true, hidden: true },
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


// 院区combogrid选择事件
function selectHospCombHandle(){

    InittSign();//医嘱大类
	initPkgGrpList();//列表
	initPkgListMenu(); //增删改
}