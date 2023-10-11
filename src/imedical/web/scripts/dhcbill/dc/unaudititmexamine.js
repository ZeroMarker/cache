/**
 * ���ݺ˲��������Ŀ���
 * FileName: dhcbill\dc\unaudititmexamine.js
 * tangzf 2022-05-11
 */
 var GV = {
	CLASSNAME:"BILL.DC.BL.UnAuditItmCtl"	 
}
//ȫ�ֱ���
var selRowid="";
var seldictype = ""; 
var ExamineFlag = "";//��˱�־
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
	//��ʼ��combobox
	$HUI.combobox("#autFlag",{
		valueField:'cCode',
    	textField:'cCode',
    	panelHeight:100
	});

	//��ʼ��datagrid
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
			{field:'ConfigDesc',title:'��ע',width:150,tipPosition:"top",showTip:true},
			{field:'ActiveFlag',title:'��˱�־',width:50,
				formatter: function(value,row,index){
	                if (row.ActiveFlag=="Y"){
	                    return "���ͨ��";
	                } 
	                else if((row.ActiveFlag=="N")&&(row.AuditId!="")) {
	                    return "��˾ܾ�";
	                }
	                else{
		                return "δ���";
		            }
	            }
			},
			{field:'AuditId',title:'�����',width:50}, 
			{field:'AuditMemo',title:'��˱�ע',width:150},
			{field:'AuditDateTime',title:'���ʱ��',width:100,
				formatter: function(value,row,index){
	                    return row.AuditDate+" "+row.AuditTime;
	            }
			},
			{field:'ConfigValue',title:'����ֵ',width:80},
			{field:'BusinessTypeName',title:'ҵ������',width:50,
				formatter: function(value,row,index){
					var BusinessTypeName=row.BusinessTypeName;
	                if (BusinessTypeName==""){
	                    BusinessTypeName="ȫ��";
	                }
	                return BusinessTypeName;
	            }
			},
			{field:'IndicatorName',title:'ָ������',width:150,
				formatter: function(value,row,index){
					var IndicatorName=row.IndicatorName;
	                if (IndicatorName==""){
	                    IndicatorName="ȫ��";
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
	
	//�ǼǺŻس���ѯ�¼�
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
        title: '��ע',
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
            text: 'ȷ��',
            iconCls: 'icon-w-save',
            handler: function() {
	            var tVal =$('#Memo').combobox("getText");
				if($('#Memo').combobox("getValue")=="others"){
					tVal=$('#inputDescDialog textarea').val();
				}
				if(tVal==""){
					$.messager.alert('��ʾ','��עΪ����ʱ,��������Ϊ��','info');
					return;
				}
				update(tVal);
				$('#inputDescDialog').dialog('close');
            }
        },{
            text: 'ȡ��',
            iconCls: 'icon-w-close',
            handler: function() {
                $('#inputDescDialog').dialog('close');
            }
        }]
    });
}
//���������Ϣ
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
	var messagetex="���"+Examine;
	if(ExamineFlag!="Y"){
		var messagetex="�ܾ����"+NotExamine;
	}
	$.messager.confirm("��ʾ", "�Ƿ�"+messagetex+"�����ݣ�", function (r) { 
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
					$.messager.alert('��ʾ','���ʧ��' + savecode,'info');
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
					$.messager.alert('��ʾ','�ܾ����ʧ��'+savecode,'info');
					return; 
				}

			}
		}
		$("#dg").datagrid('reload');
		$("#dg").datagrid('unselectAll');
		$.messager.alert('��ʾ','�����ɹ�!','info');
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
				 option.title = $('#diccbx').combobox("getText")+"����";
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
			$.messager.alert('��ʾ','�빴ѡҪ��˵�����!','info');
			return;
		}
		else if(Examine==0)
		{
			$.messager.alert('��ʾ','ѡ�е�ָ�������,������ѡ��!','info');	
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
			$.messager.alert('��ʾ','�빴ѡҪ�ܾ���˵�����!','info');
			return;
		}
		else if(NotExamine==0)
		{
			$.messager.alert('��ʾ','ѡ�е�ָ���Ѿܾ����,������ѡ��!','info');	
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


//��ѯ�ֵ�����
function Querydic(){
	$('#dg').datagrid('loadData',{total:0,rows:[]});
	// tangzf 2020-6-17 ʹ��HISUI�ӿ� ��������
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

//�����ַ�����
function SplVCFormat(FStr)
{
	return  FStr.replace(/\^/g,"");
}

