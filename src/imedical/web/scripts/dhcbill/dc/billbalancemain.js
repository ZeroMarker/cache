/**
 * FileName: dhcbill.dc.billbalancemain.js
 * Author: tangzf
 * Date: 2022-06-6
 * Description: 账单平衡性校验
 */

 var GV = {
	CLASSNAME:"BILL.DC.BL.DicDataCtl"	 
}
 var OutJson = "";
 var tmpselRow = -1;
 var tmpselpbdRow = -1;
 var tmpselpboRow = -1;
 var TPBAndPBOColor='red';
var TPBOAndPBDColor="#4507c9";
var TPBSelfAndPBOColor='#ba0c0c';
var TPBOSelfAndPBDColor="#9c0ac9"
 var HospDr=session['LOGON.HOSPID'];
 var REG = new RegExp("[\\U4E00-\\U9FFF]","g")
//界面入口
$(function(){
	//回车事件    
	key_enter();
	// 产品线
	//ini_ProductLine();	
	//业务类型box
	//ini_YWLX();
	
	//默认时间
	setDateBox();
	// 提示信息
    init_hospital();
	// grid
	init_dg();

	//  操作员
	//InitUser();
	RunQuery();
});
function init_hospital(){
	var tableName = "User.INSUTarContrast";
	var defHospId = session['LOGON.HOSPID'];//2;//
	$("#hospital").combobox({
		panelHeight: 150,
		url: $URL + '?ClassName=web.DHCBL.BDP.BDPMappingHOSP&QueryName=GetHospDataForCombo&ResultSetType=array&tablename=' + tableName,
		method: 'GET',
		valueField: 'HOSPRowId',
		textField: 'HOSPDesc',
		editable: false,
		blurValidValue: true,
		onLoadSuccess: function(data) {
			$(this).combobox('select', defHospId);
		},
		onChange: function(newValue, oldValue) {
			//RunQuery();
		}
	});
}
//数据面板
function init_dg(){
	$HUI.datagrid("#dg", {
		fit: true,
		border: false,
		singleSelect: true,
		//fitColumns: true,
		pageSize: 9999999,
		displayMsg: '',
		toolbar:[],
		columns: [[
			{title: 'Rowid', field: 'Rowid', hidden: true}, 
			{title: '登记号', field: 'RegNo', width: 100},
			{title: '姓名', field: 'PatName', width: 60},
			{title: '帐单号', field: 'ErrBill', width: 60},
			{title: '帐单总金额', field: 'PBAmount', width: 90,align:'right'},
			{title: '帐单自付金额', field: 'PBPatientShare', width: 100,align:'right'},
			{title: '提示信息', field: 'Message', width: 700,align:'left',tipTrackMouse:true,showTip:true,tipPosition:"top"}
			//{title: 'PBD', field: 'ShowPBD', width: 90},
			//{title: 'PBD总金额', field: 'PBDTotalAmount', width: 110,align:'right'},
			//{title: 'PBD自负金额', field: 'PBDPatientShare', width: 110,align:'right'},
			//{title: '账单日期', field: 'ShowPBD', width: 90}
			
		]],
		onClickRow : function(rowIndex, rowData) {
			//var temp = $('#dgtext').layout('panel','west');
	        if(tmpselRow==rowIndex){
		        tmpselRow=-1
		        $(this).datagrid('unselectRow',rowIndex)
		        var pbodgData={total:0,rows:[],curPage: 1};
		        $('#pbodg').datagrid('loadData',pbodgData);
		        $('#pbddg').datagrid('loadData',pbodgData);
		        var html='<div class=\"panel-title panel-with-icon\">账单</table></div></div><div class=\"panel-icon icon-paper-info\"></div><div class=\"panel-tool\"><a href=\"javascript:void(0)\" class=\"layout-button-left\" style=\"display: none;\"></a></div>';
				$('.panel-header-gray')[0].innerHTML=html;
				var html1='<div class=\"panel-title panel-with-icon\">账单医嘱</div><div class=\"panel-icon icon-write-order\"></div><div class=\"panel-tool\"><a href=\"javascript:void(0)\" class=\"layout-button-up\" style=\"display: none;\"></a></div>';
				$('.panel-header-gray')[1].innerHTML=html1;
		    }else{
			    $('#ErrCode').attr("disabled",true);
			    var text="";
			    if(rowData['Message']!=""){
				    text="账单总金额"+rowData['PBAmount']+"和账单医嘱总金额"+rowData['PBOToTalAmount'].split(':')[1]+"不平";
				    }
				//var html='<div class=\"panel-title panel-with-icon\">账单<label style="width: 515px;font-size:13px;text-align:right;color: red;display: inline-block;">'+text+'</label></div><div class=\"panel-icon icon-paper-info\"></div><div class=\"panel-tool\"><a href=\"javascript:void(0)\" class=\"layout-button-left\" style=\"display: none;\"></a></div>';
				var html='<div class=\"panel-title panel-with-icon\">账单</div><div class=\"panel-icon icon-paper-info\"></div><div class=\"panel-tool\" style="font-size:13px;color: red;margin-right: 5px;">'+text+'</div>';
				$('.panel-header-gray')[0].innerHTML=html;
				var html1='<div class=\"panel-title panel-with-icon\">账单医嘱</div><div class=\"panel-icon icon-write-order\"></div><div class=\"panel-tool\"><a href=\"javascript:void(0)\" class=\"layout-button-up\" style=\"display: none;\"></a></div>';
				$('.panel-header-gray')[1].innerHTML=html1;
			    //temp.panel('setTitle',text);//给区域面板title赋值
			    tmpselRow=rowIndex
			    var pboDatarows=0;
			    var pboData={total:0,rows:[],curPage: 1};
			    for(i=0;i<OutJson.rows.length;i++){
				    if(rowData['ErrBill']==OutJson.rows[i]['ErrBill']&&OutJson.rows[i]['ShowPBO']!=""){
							pboData.rows[pboDatarows]=OutJson.rows[i];
							if(pboData.rows[pboDatarows]['PBOToTalAmount']!=pboData.rows[pboDatarows]['PBDTotalAmount'].split(':')[1]||pboData.rows[pboDatarows]['PBOPatientShare']!=pboData.rows[pboDatarows]['PBDPatientShare'].split(':')[1]){
							pboData.rows[pboDatarows]['Message']="账单医嘱和账单明细不平,账单医嘱总金额:"+pboData.rows[pboDatarows]['PBOToTalAmount']+"账单自负金额:"+pboData.rows[pboDatarows]['PBOPatientShare']+"账单医嘱总金额:"+pboData.rows[pboDatarows]['PBDTotalAmount'].split(':')[1]+"账单医嘱自负金额:"+pboData.rows[pboDatarows]['PBDPatientShare'].split(':')[1];
							}
							else{
							pboData.rows[pboDatarows]['Message']="";
							}
							pboDatarows=pboDatarows+1;
						}
					};
				$('#pbodg').datagrid('loadData',pboData);
				var pbodData={total:0,rows:[],curPage: 1};
		        $('#pbddg').datagrid('loadData',pbodData);
			}
        },
        onUnselect: function(rowIndex, rowData) {
        	//alert(rowIndex+"-"+rowData.itemid)
        },
		onLoadSuccess: function(data) {
			$(this).treegrid('unselectAll');
		},
		onSelect: function() {
			//loadConfPage();
		},
		onLoadError:function(a){
			//alert(2)
		}
	});
	$HUI.datagrid("#pbodg", {
		fit: true,
		border: false,
		singleSelect: true,
		//fitColumns: true,
		pageSize: 99999,
		displayMsg: '',
		toolbar:[],
		columns: [[
			{title: '医嘱名称', field: 'PBPatientShare', width: 140},
			{title: 'PBO', field: 'ShowPBO', width: 75},
			{title: 'PBO总金额', field: 'PBOToTalAmount', width: 90,align:'right'},
			{title: 'PBO自付金额', field: 'PBOPatientShare', width: 110,align:'right'},
			{title: 'PBD总金额', field: 'PBDTotalAmount', width: 90,align:'right'},
			{title: 'PBD自付金额', field: 'PBDPatientShare', width: 110,align:'right'},
			{title: '提示信息', field: 'Message', width: 700,align:'left',tipTrackMouse:true,showTip:true,tipPosition:"top"}
			//{title: '账单日期', field: 'ShowPBD', width: 90}
			
		]],
		onClickRow : function(rowIndex, rowData) {
	        if(tmpselpboRow==rowIndex){
		        tmpselpboRow=-1
		        $(this).datagrid('unselectRow',rowIndex)
		        var html='<div class=\"panel-title panel-with-icon\">账单医嘱</div><div class=\"panel-icon icon-write-order\"></div><div class=\"panel-tool\"><a href=\"javascript:void(0)\" class=\"layout-button-up\" style=\"display: none;\"></a></div>';
				$('.panel-header-gray')[1].innerHTML=html;
		        var pbodData={total:0,rows:[],curPage: 1};
		        $('#pbddg').datagrid('loadData',pbodData);
		    }else{
			    $('#ErrCode').attr("disabled",true);
			    var text="";
			    if(rowData['Message']!=""){
				    text="账单医嘱总金额"+rowData['PBOToTalAmount']+"和账单明细总金额"+rowData['PBDTotalAmount'].split(':')[1]+"不平";
				    }
				//var html='<div class=\"panel-title panel-with-icon\">账单医嘱<label style="width: 528px;font-size:13px;text-align:right;color: red;display: inline-block;">'+text+'</label></div><div class=\"panel-icon icon-write-order\"></div><div class=\"panel-tool\"><a href=\"javascript:void(0)\" class=\"layout-button-up\" style=\"display: none;\"></a></div>';
				var html='<div class=\"panel-title panel-with-icon\">账单医嘱</div><div class=\"panel-icon icon-write-order\"></div><div class=\"panel-tool\" style="font-size:13px;color: red;margin-right: 5px;">'+text+'</div>';
								
				$('.panel-header-gray')[1].innerHTML=html;
			    tmpselpboRow=rowIndex
			    var pbdDatarows=0;
			    var pbdData={total:0,rows:[],curPage: 1};
			    for(i=0;i<OutJson.rows.length;i++){
				    if(OutJson.rows[i]['ShowPBD'].indexOf(rowData['ShowPBO'])!=-1){
							pbdData.rows[pbdDatarows]=OutJson.rows[i];
							pbdDatarows=pbdDatarows+1;
						}
					};
				$('#pbddg').datagrid('loadData',pbdData);
			}
        },
        onUnselect: function(rowIndex, rowData) {
        	//alert(rowIndex+"-"+rowData.itemid)
        },
		onLoadSuccess: function(data) {
			$(this).treegrid('unselectAll');
		},
		onSelect: function() {
			//loadConfPage();
		},
		onLoadError:function(a){
			//alert(2)
		}
		
	});
	$HUI.datagrid("#pbddg", {
		fit: true,
		border: false,
		singleSelect: true,
		//fitColumns: true,
		pagination: false,
		pageSize: 99999,
		displayMsg: '',
		toolbar:[],
		columns: [[
			{title: '收费项名称', field: 'PBOPatientShare', width: 140},
			{title: 'PBD', field: 'ShowPBD', width: 75},
			{title: 'PBD总金额', field: 'PBDTotalAmount', width: 90,align:'right'},
			{title: 'PBD自付金额', field: 'PBDPatientShare', width: 110,align:'right'},
			{title: '账单日期', field: 'PBDBillDate', width: 90}
		]],
		onClickRow : function(rowIndex, rowData) {
	        if(tmpselpbdRow==rowIndex){
		        tmpselpbdRow=-1
		        $(this).datagrid('unselectRow',rowIndex);
		    }else{
			    $('#ErrCode').attr("disabled",true);
			    tmpselpbdRow=rowIndex;
		    }
        },
		onLoadSuccess: function(data) {
			$(this).treegrid('unselectAll');
		},
		onSelect: function() {
			//loadConfPage();
		},
		onLoadError:function(a){
			//alert(2)
		}
	});
	
}

//查询
function RunQuery() {
	var pbodData={total:0,rows:[],curPage: 1};
	$('#pbodg').datagrid('loadData',pbodData);
	$('#pbddg').datagrid('loadData',pbodData);
	var html='<div class=\"panel-title panel-with-icon\">账单</table></div></div><div class=\"panel-icon icon-paper-info\"></div><div class=\"panel-tool\"><a href=\"javascript:void(0)\" class=\"layout-button-left\" style=\"display: none;\"></a></div>';
	$('.panel-header-gray')[0].innerHTML=html;
	var html1='<div class=\"panel-title panel-with-icon\">账单医嘱</div><div class=\"panel-icon icon-write-order\"></div><div class=\"panel-tool\"><a href=\"javascript:void(0)\" class=\"layout-button-up\" style=\"display: none;\"></a></div>';
	$('.panel-header-gray')[1].innerHTML=html1;
	ClearGrid("ckDet");
	var RegNo=getValueById("RegNo");
	var PatName=getValueById("PatName");
	var AdmId=getValueById("AdmDr");
	var Bill=getValueById("PBDr");
	var StartDate=getValueById("StartDate");
	var EndDate=getValueById("EndDate");
	var Hospital=getValueById("hospital")==""?session['LOGON.HOSPID']:getValueById("hospital");
	var ExpStr = RegNo + "|" + Bill + "|" + AdmId + "|" + PatName + "|"+Hospital;
	$.cm({
		ClassName: "BILL.DC.Common",
		QueryName: "QueryBillBalanceError",
		StartDate:StartDate,
		EndDate:EndDate, 
		StartTime : "",
		EndTime : "",
		ExpStr:ExpStr,
		rows:999999
	},function(jsonData){	

		for (i=0;i<jsonData.rows.length;i++){
			if(jsonData.rows[i]._parentId == ""){
				jsonData.rows[i]['state']='closed';
			}
			if(jsonData.rows[i].Rowid.indexOf("O") >-1){
				jsonData.rows[i]['state']='closed';
			}
		};
		jsonData.total = jsonData.rows.length;
		OutJson=jsonData;
		var dgData={total:0,rows:[],curPage: 1};
		dgDatarows=0;
		for(i=0;i<jsonData.rows.length;i++){
			if(dgDatarows==0&&OutJson.rows[i]['RegNo']!=""){
					dgData.rows[dgDatarows]=jsonData.rows[i];
					if(dgData.rows[dgDatarows]['PBAmount']!=dgData.rows[dgDatarows]['PBOToTalAmount'].split(':')[1]||dgData.rows[dgDatarows]['PBPatientShare']!=dgData.rows[dgDatarows]['PBOPatientShare'].split(':')[1]){
					dgData.rows[dgDatarows]['Message']="账单和账单医嘱不平,账单总金额:"+dgData.rows[dgDatarows]['PBAmount']+"账单自付金额:"+dgData.rows[dgDatarows]['PBPatientShare']+"账单医嘱总金额:"+dgData.rows[dgDatarows]['PBOToTalAmount'].split(':')[1]+"账单医嘱自付金额:"+dgData.rows[dgDatarows]['PBOPatientShare'].split(':')[1];
					}
				else{
					dgData.rows[dgDatarows]['Message']="";
					}
					dgDatarows=dgDatarows+1;
				}
			else if(dgDatarows>0&&dgData.rows[dgDatarows-1]['ErrBill']!=jsonData.rows[i]['ErrBill']&&OutJson.rows[i]['RegNo']!=""){
				dgData.rows[dgDatarows]=jsonData.rows[i];
				if(dgData.rows[dgDatarows]['PBAmount']!=dgData.rows[dgDatarows]['PBOToTalAmount'].split(':')[1]||dgData.rows[dgDatarows]['PBPatientShare']!=dgData.rows[dgDatarows]['PBOPatientShare'].split(':')[1]){
							dgData.rows[dgDatarows]['Message']="账单和账单医嘱不平,账单总金额:"+dgData.rows[dgDatarows]['PBAmount']+"账单自付金额:"+dgData.rows[dgDatarows]['PBPatientShare']+"账单医嘱总金额:"+dgData.rows[dgDatarows]['PBOToTalAmount'].split(':')[1]+"账单医嘱自付金额:"+dgData.rows[dgDatarows]['PBOPatientShare'].split(':')[1];
					}
				else{
					dgData.rows[dgDatarows]['Message']="";
					}
				dgDatarows=dgDatarows+1;
				}

			};
		dgData.total = dgDatarows;
		$('#dg').datagrid('loadData',dgData);
	});
}
function ClearGrid(gridid){
	$('#' + gridid).datagrid('loadData',{total:0,rows:[]});
	$('#' + gridid).datagrid('unselectAll');
	$('#' + gridid).datagrid('clearChecked');
}
//默认时间
function setDateBox() {
	$('#StartDate').datebox({
		onSelect:function(date){
			var daydiff=DateDiff(getDefStDate(-1),date)
			if(daydiff>0){
				$.messager.alert('提示','起始时间必须小于T。','info');
				setValueById('StartDate',getDefStDate(-1));
				return ;
			}
		}	
	})
 	$('#EndDate').datebox({
		onSelect:function(date){
			var daydiff=DateDiff(getValueById('StartDate'),date)
			if(daydiff<0){
				$.messager.alert('提示','结束时间不能小于起始时间!。','info');
				setValueById('EndDate',getDefStDate(-1));
				return;
			}
			daydiff=DateDiff(getDefStDate(-1),date)
			if(daydiff>0){
				$.messager.alert('提示','结束时间必须小于T。','info');
				setValueById('EndDate',getDefStDate(-1));
				return ;
			}
		}	
	}) 
	setValueById('StartDate',getDefStDate(-1));
	setValueById('EndDate',getDefStDate(-1));
}
function DateDiff(sDate, eDate) {
	var date1 = new Date(sDate);
	var date2 = new Date(eDate);
	var date3=date2.getTime()-date1.getTime();
	var days=Math.floor(date3/(24*3600*1000));
	return days+1;
}
///回车
function key_enter() {
	$('#PatName').keyup(function (event) {
		if (event.keyCode == 13) {
			RunQuery();
		}
	});
	$('#PBDr').keyup(function (event) {
		if (event.keyCode == 13) {
			RunQuery();
		}
	});
	$('#RegNo').keyup(function (event) {
		if (event.keyCode == 13) {
			var PatientNo=$("#RegNo").val();
			if (PatientNo!='') {
				if (PatientNo.length<10) {
					for (var i=(10-PatientNo.length-1); i>=0; i--) {
						PatientNo="0"+PatientNo;
					}
				}
			}
			$("#RegNo").val(PatientNo);
			RunQuery();
		}
	});
	$('#AdmDr').keyup(function (event) {
		if (event.keyCode == 13) {
			RunQuery();
		}
	});
}
//清屏
function clear_click() {
	//$('#tQueryPanel').form('clear');
	setValueById('PatName','');
	setValueById('PBDr','');
	setValueById('RegNo','');
	setValueById('AdmDr','');
	setDateBox();
	RunQuery();	
}
//业务类型
function ini_YWLX() {
	$HUI.combogrid("#YWLX", {
		url: $URL,
		idField: "cCode",
		textField: "cDesc",
		singleSelect: true,
		panelWidth: 430,
		onBeforeLoad:function(param){
			param.ClassName = 'web.INSUDicDataCom';
			param.QueryName= 'QueryDic';
			param.Type = 'INSUMsgYWLX';
			param.ExpStr = 'N|' + $("#ProductLine").combobox('getValue');
			param.HospDr = HospDr;
			return true;

		},
		columns: [[
			{ title: '代码', field: 'cCode', width: 200 },
			{ title: '描述', field: 'cDesc', width: 200 }
		]]
	})
}
// 产品线
function ini_ProductLine() {
	$HUI.combogrid("#ProductLine", {
		url: $URL + "?ClassName=web.INSUDicDataCom&QueryName=QueryDic&Type=ProductLine"+'&HospDr='+HospDr+'&ExpStr=N',
		idField: "cCode",
		textField: "cDesc",
		singleSelect: true,
		panelWidth: 430,
		columns: [[
			{ title: '代码', field: 'cCode', width: 200 },
			{ title: '描述', field: 'cDesc', width: 200 }
		]],
		onLoadSuccess:function(data){
					
		},
		onSelect:function(){
			$('#YWLX').combogrid('grid').datagrid('reload');
		}
	})
}
/**
 * Creator: tangzf
 * CreatDate: 2019-7-10
 * Description: 生成次级弹窗Modifydl
 * input:	msg : 提示内容
 * 			buttonType : 是否显示按钮 "disable" 不显示
 * 			title : 弹窗标题
 */
function openCellWindow(msg,buttonType,title){
	$('#editCode').val(msg);
	$('#Modifydl').panel({
    	title:title,
 	});
	$("#saveBtn").linkbutton(buttonType);
	if(buttonType=="disable"){
		$("#saveBtn").hide();	
	}else{
		$("#saveBtn").show();	
	}
	$('#Modifydl').window('open');	
}
function InitUser(){
	$('#UserCode').combobox({
		valueField: 'Desc',
		textField: 'Desc',
		url:$URL,
		defaultFilter:'4',
		onBeforeLoad:function(param){
			param.ClassName = 'web.INSUReport';
			param.QueryName= 'FindSSUser';
			param.ResultSetType = 'array';
			param.HospId = HospDr;
		},onLoadSuccess:function(data){
		},onLoadError:function(){
		}	
	});	
}
