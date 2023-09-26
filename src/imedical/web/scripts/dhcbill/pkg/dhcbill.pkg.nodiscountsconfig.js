/*
 * FileName:	dhcbill.pkgnodiscountsconfig.js
 * User:		WangRan
 * Date:		2019-09-18
 * Function:	医嘱不打折项配置
 * Description: 
*/


var EditRowIndex=undefined;
var LocRowIndex=-1;
var LocRecRowIndex=-1;
var PkgGrpL;
var NowDate="";
var NowTime="";
var TarcatData=""
var TarsubcatData=""
var UserDR=session['LOGON.USERID'];
//var HospDr=PUBLIC_CONSTANT.SESSION.HOSPID;
var GroupDr=session['LOGON.GROUPID'];
//Rowid^医嘱项大类dr^医嘱项子类dr^医嘱项dr^创建日期^创建时间^修改日期^修改时间^创建人^修改人^备注^医院ID^生效开始日期^生效结束日期
var TarcatDr=""
var TarsubcatDr=""
var ItemDr=""

//var CreatDate=""
//var CreatTime=""
//var UpdateDate=""
//var UpdateTime=""
//var CreatUserDr=""
//var UpdateUserDr=""
//var Mark=""
//var HospDr=PUBLIC_CONSTANT.SESSION.HOSPID;
//var StartDate=""
//var EndDate=""
//var RowId=""
//var String="^"+TarcatDr+"^"+TarsubcatDr+"^"+ItemDr+"^"+CreatDate+"^"+CreatTime+"^"+UpdateDate+"^"+UpdateTime+"^"+CreatUserDr+"^"+UpdateUserDr+"^"+Mark+"^"+HospDr+"^"+StartDate+"^"+EndDate
 $(function () {

	InitOrdCat();//医嘱大类
	InitOrdCatSub();//医嘱子类
	InitItmMast();//医嘱项  
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


function InitOrdCat(){
 $HUI.combobox("#tTOrdCat",{	//医嘱大类
		valueField:'Id',
		textField:'Desc',
		url:$URL,
		defaultFilter:4,
		//limitToList:true,
		
		onBeforeLoad:function(para){
			para.ClassName='BILL.PKG.BL.NoDiscountsConfig'
			para.QueryName='QueryOrderCategory'
			para.KeyWords=""
			para.ResultSetType='Array';
		},	
		onLoadSuccess:function(){
			
		},
		onLoadError:function(err){
		
		},
		onChange:function(data){
				
		},
		onSelect:function(data){
			//setValueById('tTOrdCat',data.Id);
			
			if(data.Id==0){
				setValueById('tTOrdCat',"");
			}
			InitOrdCatSub();//医嘱子类
			InitItmMast();//医嘱项 
			initPkgGrpList(); 
		
		}	
	})
}
function InitOrdCatSub(){ 
	var TOrdCatSub=getValueById('tTOrdCatSub');
			if(typeof(TOrdCatSub)=="undefined"){
				setValueById('tTOrdCatSub',"")
			}
	$HUI.combobox("#tTOrdCatSub",{	//医嘱子类
			  valueField:'Id',
			  textField:'Desc',
			  url:$URL,
			  defaultFilter:4,
			  limitToList:true,
			  onBeforeLoad:function(para){
			  para.ClassName='BILL.PKG.BL.NoDiscountsConfig'
			  para.QueryName='QueryARCItemCat'
			  para.OrdCatDr=getValueById('tTOrdCat')
			  para.KeyWords=""
			  para.ResultSetType='Array';
			  },	
			  onLoadSuccess:function(){
			
			  },
			  onChange:function(newVal,oldVal){
				InitItmMast();
				},
			  onLoadError:function(err){
			
			  },
			  onSelect:function(data){
				  
				//setValueById('tTOrdCatSub',data.Id);
				//InitItmMast();//医嘱项  
				InitItmMast();
				initPkgGrpList();
			  }	
	})
 
}
function InitItmMast(){
	$HUI.combobox("#tTItmMast",{	//医嘱项目
			  valueField:'ItemDr',
			  textField:'ItemDesc',
			  url:$URL,
			  defaultFilter:4,
			  onBeforeLoad:function(para){
			  para.ClassName='BILL.PKG.BL.NoDiscountsConfig'
			  para.QueryName='QueryNoDiscountsConfig'
			  para.OrdCatDr=getValueById('tTOrdCat')
			  para.OrdCatSubDr=getValueById('tTOrdCatSub')
			  para.ArcItmDr=""
			  para.HospDr=PUBLIC_CONSTANT.SESSION.HOSPID;
			  para.ResultSetType='Array';
			  },	
			  onLoadSuccess:function(){
				
			  },
			  onLoadError:function(err){

			  },
			  onChange:function(oldVal,newVal){
						
				
				},
			  onSelect:function(data){
				setValueById('tTItmMast',data.ItemDr);
				//alert(getValueById('tTItmMast'))
				//InitItmMast();//医嘱项  
				
			  }	
	})
}


function InitItmMastold(){
	$HUI.combobox("#tTItmMast",{	//医嘱项    (Alias As %String, OrdCatDr As %String = "", OrdCatSubDr As %String = "")
		valueField:'ArcimRowID',      //ArcimRowID:%String,ArcimDesc:%String,selected:%Boolean
		textField:'ArcimDesc',
		mode: 'remote',
		multiple:false,
		selectOnNavigation:false,
		panelHeight:"auto",
		editable:true,
		url:$URL,
		filter:function(Alias,row){},
		onBeforeLoad:function(param){
				param.ClassName = "BILL.PKG.BL.NoDiscountsConfig";
				param.QueryName = "FindAllItem";
				param.Alias=param.q
				
				//alert(getValueById('tTOrdCat')+"+"+getValueById('tTOrdCatSub'))
				param.OrdCatDr=getValueById('tTOrdCat')
				param.OrdCatSubDr=getValueById('tTOrdCatSub')
				param.ResultSetType='Array';
		},	
		onLoadSuccess:function(data){
			
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
			setValueById('tTItmMast',data.ArcimRowID);
			
		}	
	})
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
			$('#BtnSave').linkbutton('disable');
			$('#BtnAdd').linkbutton('enable');
			$('#BtnUpdate').linkbutton('enable');
			EditRowIndex = undefined;
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

function updateClick() {
	var row = PkgGrpL.getSelected();//选中行对象
	EditRowIndex =PkgGrpL.getRowIndex(row);//当前行行号
	//PkgGrpL.selectRow(EditRowIndex);//选择行
	PkgGrpL.beginEdit(EditRowIndex);//编辑行
	//HISUIDataGrid.setFieldValue(TarcatDesc,"",EditRowIndex,"dg")
	//HISUIDataGrid.setFieldValue(TarsubcatDesc,"",EditRowIndex,"dg")
	//HISUIDataGrid.setFieldValue(ItemDesc,"",EditRowIndex,"dg")
	
	
}


function saveClick(){               //保存
	//var rtn = tkMakeServerCall("web.DHCOPBillChargExcepiton", "GetOrdStatus", PrtRowID);
	PkgGrpL.endEdit(EditRowIndex);
	PkgGrpL.acceptChanges();
	var row = PkgGrpL.getSelected();
	//alert(row.ItemDesc)
	if((row.TarcatDesc == "") && (row.TarsubcatDesc == "")&& (row.ItemDesc == "")){
				$.messager.alert('消息',"医嘱子类与医嘱大类与医嘱项同时为空,不允许添加!");
				EditRowIndex=-1;
				
				//return;
			}
	var StartDate=row.StartDate		
	if(StartDate == ""){
			getNowDateTime()
	    StartDate=NowDate;	
				
			}
	if (EditRowIndex != -1) {
	//var TarcatDr=row.TarcatDr	
    //var TarsubcatDr=row.TarsubcatDr
    //var ItemDr=row.ItemDr
	
    var CreatDate=row.CreatDate  //用作创建或修改的标志
    var CreatTime=row.CreatTime
    var CreatUserDr=row.CreatUserDr
    var Mark=row.Mark
    
    var EndDate=row.EntDate
    var UpdateDate=""
	var UpdateTime=""
//	var CreatUserDr=""
	var UpdateUserDr=""
    ///alert(CreatDate)
    if(CreatDate==""){
	    getNowDateTime()
	    CreatDate=NowDate;
		CreatTime=NowTime
		CreatUserDr=UserDR
		RowId=""
		//ItemDr=row.ItemDesc
		if(row.ItemDesc!=""){
		var result=row.ItemDesc.split(",");
		var length=result.length
		var leng=length
   		for(var i=0;i<length;i++){
    	ItemId=result[i];
    	
    	if(ItemId.indexOf("||") != -1 ){
	    	
		var StringData=RowId+"^"+TarcatDr+"^"+TarsubcatDr+"^"+ItemId+"^"+CreatDate+"^"+CreatTime+"^"+UpdateDate+"^"+UpdateTime+"^"+CreatUserDr+"^"+UpdateUserDr+"^"+Mark+"^"+PUBLIC_CONSTANT.SESSION.HOSPID+"^"+StartDate+"^"+EndDate
		var rtn = tkMakeServerCall("BILL.PKG.BL.NoDiscountsConfig", "Save", StringData);
		if(rtn>=0){
		}
		else{alert(rtn)}
   		}else{
	   		leng=leng-1;
   		}
   		}
   		$.messager.alert('提示', "添加"+(leng)+"条成功", 'success');
		}else{
		var StringData=RowId+"^"+TarcatDr+"^"+TarsubcatDr+"^"+ItemDr+"^"+CreatDate+"^"+CreatTime+"^"+UpdateDate+"^"+UpdateTime+"^"+CreatUserDr+"^"+UpdateUserDr+"^"+Mark+"^"+PUBLIC_CONSTANT.SESSION.HOSPID+"^"+StartDate+"^"+EndDate
		var rtn = tkMakeServerCall("BILL.PKG.BL.NoDiscountsConfig", "Save", StringData);
		if(rtn>=0){
		$.messager.alert('提示', "添加成功", 'success');
		}
		else{alert(rtn)}	
			
		}
	}
		
    else{
	    if(TarcatDr==""||TarcatDr==0){
		TarcatDr=row.TarcatDr
		//alert(TarcatDr+"1213")
	}
	if(TarsubcatDr==""||TarsubcatDr==0){
		TarsubcatDr=row.TarsubcatDr
	}
	if(ItemDr==""||ItemDr==0){
		ItemDr=row.ItemDr
	}else{
		var result=row.ItemDesc.split(",");
		var length=result.length
    	ItemId=result[length-1];
		//ItemDr=	ItemDr.split(",")[1];
	}
	    getNowDateTime()
    	UpdateDate=NowDate
    	UpdateTime=NowTime
    	UpdateUserDr=UserDR
    	RowId=row.Id 
    	var StringData=RowId+"^"+TarcatDr+"^"+TarsubcatDr+"^"+ItemId+"^"+CreatDate+"^"+CreatTime+"^"+UpdateDate+"^"+UpdateTime+"^"+CreatUserDr+"^"+UpdateUserDr+"^"+Mark+"^"+PUBLIC_CONSTANT.SESSION.HOSPID +"^"+StartDate+"^"+EndDate
		var rtn = tkMakeServerCall("BILL.PKG.BL.NoDiscountsConfig", "Save", StringData);
		if(rtn>=0){
		$.messager.alert('提示', "修改成功", 'success');
		}
		else{alert(rtn)}
   			
	}
	}
	TarcatDr=""
    TarsubcatDr=""
    ItemId=""

	$('#BtnSave').linkbutton('disable');
	$('#BtnAdd').linkbutton('enable');
	$('#BtnUpdate').linkbutton('enable');
	initPkgGrpList();
	
	EditRowIndex = undefined;
	
	
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


function initPkgGrpList() { //(OrdCatDr As %String = "", OrdCatSubDr As %String = "", ArcKeyWords As %String = "", HospDr As %String = "")
	 var loadSuccess = false;
	PkgGrpL= $HUI.datagrid("#dg", {
		url:$URL + "?ClassName=BILL.PKG.BL.NoDiscountsConfig&QueryName=QueryNoDiscountsConfig&ArcItmDr="+getValueById('tTItmMast')+"&OrdCatDr="+getValueById('tTOrdCat')+"&OrdCatSubDr="+getValueById('tTOrdCatSub')+"&HospDr="+PUBLIC_CONSTANT.SESSION.HOSPID ,
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
					{ field: 'TarcatDesc', title: '医嘱大类', width: 100, align: 'center', sortable: true, resizable: true,
					
					editor:{
						type: 'combobox',
						options: {
						//editable:false,
						panelHeight: 'auto',
					   	valueField:'Id',
						textField:'Desc',
						limitToList:true,
						method:'remote',
						url:$URL,
						defaultFilter:4,
						onBeforeLoad:function(para){
						para.ClassName='BILL.PKG.BL.NoDiscountsConfig'
						para.QueryName='QueryOrderCategory'
						para.KeyWords=""
						
						para.ResultSetType='Array';
						},	
						onLoadSuccess:function(){
			
						},
						onLoadError:function(err){
			
						},
						onSelect:function(data){
							if(data.Id==0){
								$(thisEd.target).combobox('clear'); 
								}
						    //TarcatData=data.Id
							TarcatDr=data.Id 
							//alert(TarcatData)
							Tarsubcat(TarcatDr)
							Item(TarcatDr,'')
							//HISUIDataGrid.setFieldValue("TarcatDr", data.Id, EditRowIndex, "dg");
						},	
						onChange:function(oldVal,newVal){
							//alert(this.Id)

		}
						}
					}
					},
					
					{ field: 'TarsubcatDesc', title: '医嘱子类', width: 100, align: 'center', sortable: true, resizable: true,
						
					editor:{
						type: 'combobox',
						options: {
						//editable:false,
						panelHeight: 'auto',
						valueField:'Id',
						textField:'Desc',
					   	limitToList:true,
						url:$URL,
						defaultFilter:4,
						onBeforeLoad:function(para){
						//para.ClassName='BILL.PKG.BL.NoDiscountsConfig'
						//para.QueryName='QueryARCItemCat'
						//para.KeyWords=""
						//para.OrdCatDr=TarcatData
						//alert(para)
						para.ResultSetType='Array';
						},	
						onLoadSuccess:function(){
			
						},
						onLoadError:function(err){
			
						},
						onSelect:function(data){
							//TarsubcatData=data.Id
							TarsubcatDr=data.Id
							Item(TarcatDr,TarsubcatDr)
							//HISUIDataGrid.setFieldValue("TarsubcatDr", data.Id, EditRowIndex, "dg")
						}
                       	
                           }
						}
					},
					{ field: 'ItemDesc', title: '医嘱项目名称', width: 400, align: 'left', sortable: true, resizable: true,
					editor:{
						type: 'combobox',
						
						options: {
						rowStyle:'checkbox', 
						multiple:true, //多选
						selectOnNavigation:false,
						enterNullValueClear:false,
						panelHeight:200,
						limitToList:true,
					   	valueField:'ArcimRowID',
						textField:'ArcimDesc',
						mode: 'remote',
						url:$URL,
						filter:function(Alias,row){},
						onBeforeLoad:function(param){
						//param.ClassName = "BILL.PKG.BL.NoDiscountsConfig";
						//param.QueryName = "FindAllItem";
						param.Alias=param.q
				
						//param.OrdCatDr=""
						//param.OrdCatSubDr=""
						param.ResultSetType='Array';
						},
						
						onLoadSuccess:function(data){
							
							//combobox.clearValue();
							
							//$("#ItemDesc").combobox('clear')
							//combobox.datasource=null
						},
						onLoadError:function(err){
			
						},
						onSelect:function(data){
							
						}
                       	
                           },
						}
					},
					{ field: 'Id', title: 'rowidID', width: 50, align: 'center', sortable: true, resizable: true, hidden: true },
					{ field: 'StartDate', title: '生效日期', width: 120, align: 'center', editor : 'datebox', sortable: true, resizable: true },
					{ field: 'EntDate', title: '结束日期', width: 120, align: 'center', editor : 'datebox', sortable: true, resizable: true },
					{ field: 'Mark', title: '备注', width: 80, align: 'center', editor : 'text', sortable: true, resizable: true },
					{ field: 'CreatDate', title: '创建日期', width: 100, align: 'center', sortable: true, resizable: true },
					{ field: 'CreatTime', title: '创建时间', width: 100, align: 'center', sortable: true, resizable: true },
					{ field: 'CreatUser', title: '创建人', width: 100, align: 'center', sortable: true, resizable: true },
					{ field: 'UpdateDate', title: '修改日期', width: 100, align: 'center', sortable: true, resizable: true },
					{ field: 'UpdateTime', title: '修改时间', width: 100, align: 'center', sortable: true, resizable: true },
					{ field: 'UpdateUser', title: '修改人', width: 100, align: 'center', sortable: true, resizable: true },
					{ field: 'Hospital', title: '院区', width: 200, align: 'center', sortable: true, resizable: true},
					{ field: 'TarcatDr', title: '医嘱大类ID', width: 50, align: 'center', sortable: true, resizable: true, hidden: true },
					{ field: 'TarsubcatDr', title: '医嘱子类ID', width: 50, align: 'center', sortable: true, resizable: true, hidden: true },
					{ field: 'ItemDr', title: '医嘱项目ID', width: 50, align: 'center', sortable: true, resizable: true, hidden: true },
					{ field: 'HospitalDr', title: '院区ID', width: 50, align: 'center', sortable: true, resizable: true, hidden: true },
					{ field: 'CreatUserDr', title: '创建人ID', width: 50, align: 'center', sortable: true, resizable: true, hidden: true },
					{ field: 'UpdateUserDr', title: '修改人ID', width: 50, align: 'center', sortable: true, resizable: true, hidden: true },
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
function Tarsubcat(TarcatData){
		var url = $URL + "?ClassName=BILL.PKG.BL.NoDiscountsConfig&QueryName=QueryARCItemCat&KeyWords=" + ''+'&OrdCatDr='+TarcatData ;

	var thisEd = $('#dg').datagrid('getEditor', {
		'index': EditRowIndex,
		'field': 'TarsubcatDesc'
	});
	$(thisEd.target).combobox('clear'); //清除原来的数据
	//置空数据
	$(thisEd.target).combobox('reload',url);
	
}

//d ##class(%ResultSet).RunQuery("BILL.PKG.BL.NoDiscountsConfig","FindAllItem","lhn","1","2","29")  OrdCatDr As %String = "", OrdCatSubDr As %String = "", GroupDr As %String = ""
function Item(TarcatDr,TarsubcatDr){
		var thisEd = $('#dg').datagrid('getEditor', {
		'index': EditRowIndex,
		'field': 'ItemDesc'
	});
	var url = $URL + "?ClassName=BILL.PKG.BL.NoDiscountsConfig&QueryName=FindAllItem&Alias=" +''+'&OrdCatDr='+TarcatDr+'&OrdCatSubDr='+TarsubcatDr+'&GroupDr='+GroupDr ;
	$(thisEd.target).combobox('clear'); //清除原来的数据
	//置空数据
	$(thisEd.target).combobox('reload',url);
	
}

// 院区combogrid选择事件
function selectHospCombHandle(){
    InitOrdCat();//医嘱大类
	InitOrdCatSub();//医嘱子类
	InitItmMast();//医嘱项  
	initPkgGrpList();//列表
	initPkgListMenu(); //增删改

}
