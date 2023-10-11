/**
 * 数据核查免审核项目审核
 * FileName: dhcbill\dc\unaudititmexamine.js
 * tangzf 2022-05-11
 */
 var GV = {
	CLASSNAME:"BILL.DC.BL.UnAuditItmCtl"	 
}
//全局变量
var selRowid="";
var seldictype = ""; 
var ExamineFlag = "";//审核标志
var tmpselRow = -1;
$(function(){

	var tableName = "CF_BILL_DC.UnAuditItm";
	var defHospId = session['LOGON.HOSPID'];
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
			Querydic();
		}
	});
	var dicSelid=0
	//初始化combobox
	$HUI.combobox("#autFlag",{
		valueField:'cCode',
    	textField:'cCode',
    	panelHeight:100
	});

	//初始化datagrid
	$HUI.datagrid("#dg",{
		data:[],
		fit: true,
		rownumbers:true,
		striped:true,
		fitColumns:true,
		singleSelect: false,
		autoRowHeight:false,
		toolbar: '#toolbar',
		checkbox:true,
		columns:[[
			{title:'', field: 'CheckOrd',checkbox:true, width: 20,tipPosition:"top",showTip:true},
			{field:'ConfigDesc',title:'备注',width:150,tipPosition:"top",showTip:true},
			{field:'ActiveFlag',title:'审核标志',width:50,
				formatter: function(value,row,index){
	                if (row.ActiveFlag=="Y"){
	                    return "审核通过";
	                } 
	                else if((row.ActiveFlag=="N")&&(row.AuditId!="")) {
	                    return "审核拒绝";
	                }
	                else{
		                return "未审核";
		            }
	            }
			},
			{field:'AuditId',title:'审核人',width:50}, 
			{field:'AuditMemo',title:'审核备注',width:150},
			{field:'AuditDateTime',title:'审核时间',width:100,
				formatter: function(value,row,index){
	                    return row.AuditDate+" "+row.AuditTime;
	            }
			},
			{field:'ConfigValue',title:'配置值',width:80},
			{field:'BusinessTypeName',title:'业务类型',width:50,
				formatter: function(value,row,index){
					var BusinessTypeName=row.BusinessTypeName;
	                if (BusinessTypeName==""){
	                    BusinessTypeName="全部";
	                }
	                return BusinessTypeName;
	            }
			},
			{field:'IndicatorName',title:'指标名称',width:150,
				formatter: function(value,row,index){
					var IndicatorName=row.IndicatorName;
	                if (IndicatorName==""){
	                    IndicatorName="全部";
	                }
	                return IndicatorName;
	            }
			},
			{field:'Rowid',title:'Rowid',width:10,hidden:true}

		]],
		pageSize: 30,
		pagination:true,
        onClickRow : function(rowIndex, rowData) {
	        if(tmpselRow==rowIndex){
		        tmpselRow=-1;
		        $(this).datagrid('unselectRow',rowIndex);
		    }else{
			    tmpselRow=rowIndex;
			}
            
        },
        onLoadSuccess: function(data) {
		 	if (data!=""&&data.total>0){
			 	return;
			}
		},
        onUnselect: function(rowIndex, rowData) {
        }
	});
	
	//登记号回车查询事件
	$("#dicKey").keydown(function (e) {
		var key = websys_getKey(e);
		if (key == 13) {
			Querydic();
		}
	});
	init_BusinessTypeQ();
	init_IndexQ('');
	Querydiccbx();
	init_BusinessTypeIdCB();
	init_ActiveFlagCB();
	InitInputDescDialog();
});
function InitInputDescDialog() {
    $('#inputDescDialog').dialog({
        autoOpen: false,
        title: '备注',
        iconCls: 'icon-w-edit',
        width: 430,
        height: 368,
        closed: true,
        cache: false,
        href: '',
        modal: true,
        resizable: true,
        buttons: [
        {
            text: '确定',
            iconCls: 'icon-w-save',
            handler: function() {
	            var tVal =$('#Memo').combobox("getText");
				if($('#Memo').combobox("getValue")=="others"){
					tVal=$('#inputDescDialog textarea').val();
				}
				if(tVal==""){
					$.messager.alert('提示','备注为其他时,描述不可为空','info');
					return;
				}
				update(tVal);
				$('#inputDescDialog').dialog('close');
            }
        },{
            text: '取消',
            iconCls: 'icon-w-close',
            handler: function() {
                $('#inputDescDialog').dialog('close');
            }
        }]
    });
}
//更新审核信息
function update(tVal)
{
	var AllRowsData= $('#dg').datagrid('getChecked');
	var Examine=0;
	var NotExamine=0;
	for(i=0;i<AllRowsData.length;i++)
	{
		if(AllRowsData[i]["ActiveFlag"]!="Y")
		{
			Examine=Examine+1;	
		}
		if(AllRowsData[i]["AuditId"]==""||AllRowsData[i]["ActiveFlag"]!="N")
		{
			NotExamine=NotExamine+1;
		}
	}
	var messagetex="审核"+Examine;
	if(ExamineFlag!="Y"){
		var messagetex="拒绝审核"+NotExamine;
	}
	$.messager.confirm("提示", "是否"+messagetex+"条数据？", function (r) { 
	if(r){
		for(i=0;i<AllRowsData.length;i++)
		{
			if(ExamineFlag=="Y")
			{
				if(AllRowsData[i]["ActiveFlag"]=="Y")
				{
					continue;	
				}
				var saveinfo=AllRowsData[i]["Rowid"]+"^"+ExamineFlag+"^"+tVal;
				var savecode=tkMakeServerCall(GV.CLASSNAME,"SaveAudit",saveinfo,session['LOGON.USERID']);
				if (eval(savecode)<0){
					$.messager.alert('提示','审核失败' + savecode,'info');
					return; 
				}
			}
			else
			{
				if(AllRowsData[i]["ActiveFlag"]=="N"&&AllRowsData[i]["AuditId"]!="")
				{
					continue;	
				}
				var saveinfo=AllRowsData[i]["Rowid"]+"^"+ExamineFlag+"^"+tVal;
				var savecode=tkMakeServerCall(GV.CLASSNAME,"SaveAudit",saveinfo,session['LOGON.USERID']);
				if (eval(savecode)<0){
					$.messager.alert('提示','拒绝审核失败'+savecode,'info');
					return; 
				}

			}
		}
		$("#dg").datagrid('reload');
		$("#dg").datagrid('unselectAll');
		$.messager.alert('提示','操作成功!','info');
		Querydic();
	} 
	else
	{
		return false;
	}});
}
function QueryDemobx(PDicType){
	$HUI.combobox("#Memo", {
		panelHeight: 150,
		url: $URL,
		editable: false,
		valueField: 'DicCode',
		textField: 'DicDesc',
		onBeforeLoad: function (param) {
			param.ClassName = "BILL.DC.BL.DicDataCtl";
			param.QueryName = "QueryInfo";
			param.HospID = getValueById("hospital");
			param.ResultSetType = 'array';
			param.KeyCode="";
			param.ExpStr="||Y";
			param.PDicType=PDicType;
		},
		onLoadSuccess: function (data) {
			if (data.length > 0) {
				$(this).combobox("select", data[0].DicCode);
			}
		},
		onChange: function(newValue,oldValue){
			if(newValue!="others")
			{
				$('#inputDescDialog textarea').attr("disabled","true");
			}
			else
			{
				$('#inputDescDialog textarea').removeAttr("disabled");
				$('#inputDescDialog textarea').focus();
			}
		}
	});
}

function Querydiccbx(){
	$HUI.combobox("#diccbx", {
		panelHeight: 150,
		url: $URL,
		editable: false,
		valueField: 'DicCode',
		textField: 'DicDesc',
		defaultFilter: 4,
		onBeforeLoad: function (param) {
			param.ClassName = "BILL.DC.BL.DicDataCtl";
			param.QueryName = "QueryInfo";
			param.HospID = 'G';//getValueById("hospital");
			param.ResultSetType = 'array';
			param.KeyCode="";
			param.ExpStr="||Y";
			param.PDicType="UnAuditType";
		},
		onLoadSuccess: function (data) {
			if (data.length > 0) {
				$(this).combobox("select", data[0].DicCode);
			}
			Querydic();
		},
		onSelect:function(record){
			Querydic();
			var option = $('#dg').datagrid("getColumnOption", "ConfigDesc");
			if(option!=null)
			{
				 option.title = $('#diccbx').combobox("getText")+"名称";
				 $('#dg').datagrid();
			}
			var option = $('#dg').datagrid("getColumnOption", "ConfigValue")
			if(option!=null)
			{
				 option.title = $('#diccbx').combobox("getText")+"ID";
				 $('#dg').datagrid();
			}
			
		}
	});
}
function Examine(Id){
	var AllRowsData= $('#dg').datagrid('getChecked');
	var Examine=0;
	var NotExamine=0;
	for(i=0;i<AllRowsData.length;i++)
	{
		if(AllRowsData[i]["ActiveFlag"]!="Y")
		{
			Examine=Examine+1;	
		}
		if(AllRowsData[i]["AuditId"]==""||AllRowsData[i]["ActiveFlag"]!="N")
		{
			NotExamine=NotExamine+1;
		}
	}
	if(Id=="0")
	{
		if(AllRowsData.length==0)
		{
			$.messager.alert('提示','请勾选要审核的数据!','info');
			return;
		}
		else if(Examine==0)
		{
			$.messager.alert('提示','选中的指标已审核,请重新选择!','info');	
			return;
		}
		ExamineFlag="Y";
	    $('#inputDescDialog textarea').val();
	    $('#inputDescDialog').dialog("open");
	    QueryDemobx("UnAuditTypeExamine");
	}
	if(Id=="1")
	{

		if(AllRowsData.length==0)
		{
			$.messager.alert('提示','请勾选要拒绝审核的数据!','info');
			return;
		}
		else if(NotExamine==0)
		{
			$.messager.alert('提示','选中的指标已拒绝审核,请重新选择!','info');	
			return;
		}
		ExamineFlag="N";
		$('#inputDescDialog textarea').val();
		$('#inputDescDialog').dialog("open");
		QueryDemobx("UnAuditTypeNotExamine");
	}
}
function init_BusinessTypeQ(){
	$HUI.combobox("#BusinessTypeCodeQ", {
		panelHeight: 150,
		url: $URL,
		editable: false,
		valueField: 'DicCode',
		textField: 'DicDesc',
		onBeforeLoad: function (param) {
			param.ClassName = "BILL.DC.BL.DicDataCtl";
			param.QueryName = "QueryInfo";
			param.HospID = "G";
			param.KeyCode="";
			param.PDicType= "BusinessTypeCode";
			param.ResultSetType = 'array';
			return true;
		},
		onLoadSuccess: function (data) {
			if (data.length > 0) {
			}
		},
		onChange:function(val){
			if(selRowid <= 0){
					
			}
			
		},
		onSelect:function(val){
		}
	});
}
function init_BusinessTypeIdCB(){
	$HUI.combobox("#BusinessTypeCode", {
		panelHeight: 150,
		url: $URL,
		editable: false,
		valueField: 'DicCode',
		textField: 'DicDesc',
		defaultFilter: 4,
		onBeforeLoad: function (param) {
			param.ClassName = "BILL.DC.BL.DicDataCtl";
			param.QueryName = "QueryInfo";
			param.HospID = "G";
			param.KeyCode="";
			param.PDicType= "BusinessTypeCode";
			param.ResultSetType = 'array';
			return true;
		},
		onLoadSuccess: function (data) {
			if (data.length > 0) {
				$(this).combobox("select", data[0].DicCode);
			}
		},
		onChange:function(val){
			init_IndicatorId(val.DicCode);
			
		},
		onSelect:function(val){
			init_IndicatorId(val.DicCode);
		}
	});
}
function init_IndexQ(val){
	$HUI.combobox("#IndicatorIdQ", {
		panelHeight: 200,
		url: $URL,
		editable: true,
		valueField: 'Code',
		textField: 'Name',
		onBeforeLoad: function (param) {
			param.ClassName = "BILL.DC.BL.IndicatorDefCtl";
			param.QueryName = "QueryInfo";
			param.HospID = getValueById("hospital");
			param.KeyCode="";
			param.PCheckType= "";
			param.QBusinessType= val;//"";
			param.ResultSetType = 'array';
		},
		onLoadSuccess: function (data) {
			if (data.length > 0) {
			}
		},
		onSelect:function(val){
		} 
	});
}
function init_IndicatorId(val){
	$HUI.combobox("#IndicatorId", {
		panelHeight: 200,
		url: $URL,
		editable: true,
		valueField: 'Code',
		textField: 'Name',
		rowStyle:'checkbox',
		multiple:true,
		onBeforeLoad: function (param) {
			param.ClassName = "BILL.DC.BL.IndicatorDefCtl";
			param.QueryName = "QueryInfo";
			param.HospID = getValueById("hospital");
			param.KeyCode="";
			param.PCheckType= "";
			param.QBusinessType= val;//"";
			param.ResultSetType = 'array';
		},
		onLoadSuccess: function (data) {
		},
	 	onChange:function(val){
		} 
	});
}

function init_CateCode(){
	$HUI.combobox("#CateCode", {
		panelHeight: 150,
		url: $URL,
		editable: false,
		valueField: 'DicCode',
		textField: 'DicDesc',
		onBeforeLoad: function (param) {
			param.ClassName = "BILL.DC.BL.DicDataCtl";
			param.QueryName = "QueryInfo";
			param.HospID = getValueById("hospital");
			param.ResultSetType = 'array';
			param.KeyCode="";
			param.ExpStr="N";
			param.PDicType="UnAuditType";
		},
		onLoadSuccess: function (data) {
			if (data.length > 0) {
				$(this).combobox("select", data[0].DicCode);
			}
		},
	    onSelect:function(val){	
		} 
	});
}


function init_ConfigValue(){
	$HUI.combobox("#ConfigValue", {
		panelHeight: 150,
		url: $URL,
		editable: true,
		valueField: 'TARIRowid',
		textField: 'TARIDesc',
		onBeforeLoad: function (param) {
			param.ClassName = GV.CLASSNAME;
			param.QueryName = "QueryDHCTarItem";
			param.ResultSetType = 'array';
		},
		onLoadSuccess: function (data) {
		},
	    onSelect:function(val){
		} 
	});
}


$('.hisui-linkbutton').bind('click',function(){
	 switch (this.id){ 
	    case "btnClearCho" :
	    	setValueById('dicKey','');
	    	var defHospId = session['LOGON.HOSPID'];
	    	$("#hospital").combobox('select', defHospId);
	    	$('#BusinessTypeCodeQ').combobox("select", "");
	    	$('#IndicatorIdQ').combobox("select", "");
	    	$('#ExamineFlag').combobox("select", "");
	    	Querydiccbx();
	    	//Querydic();
	    	break;
	    default :
	    	break;
	    }
		
}) 

function init_ActiveFlagCB(){
	$HUI.combobox("#ActiveFlag", {
		panelHeight: 150,
		url: $URL,
		editable: false,
		valueField: 'DicCode',
		textField: 'DicDesc',
		onBeforeLoad: function (param) {
			param.ClassName = "BILL.DC.BL.DicDataCtl";
			param.QueryName = "QueryInfo";
			param.HospID = "G";
			param.KeyCode="";
			param.PDicType= "ActiveFlag";
			param.ResultSetType = 'array';
			return true;
		},
		onLoadSuccess: function (data) {
			if (data.length > 1) {
				$(this).combobox("select", data[0].DicCode);
			}
		}
	});
}


//查询字典数据
function Querydic(){
	$('#dg').datagrid('loadData',{total:0,rows:[]});
	// tangzf 2020-6-17 使用HISUI接口 加载数据
	var QueryParam={
		ClassName: GV.CLASSNAME,
		QueryName: 'QueryUnAuditItm',
		KeyCode: getValueById('dicKey'),
		HospID : getValueById("hospital")==""?session['LOGON.HOSPID']:getValueById("hospital"),
		BusinessType : getValueById('BusinessTypeCodeQ'),
		IndexCode :  getValueById('IndicatorIdQ'),
		CateCode:$('#diccbx').combobox('getValue'),
		ExamineFlag:$('#ExamineFlag').combobox('getValue')
	}
	seldictype=$('#diccbx').combobox('getValue');
	loadDataGridStore('dg',QueryParam);
}

//特殊字符处理
function SplVCFormat(FStr)
{
	return  FStr.replace(/\^/g,"");
}

