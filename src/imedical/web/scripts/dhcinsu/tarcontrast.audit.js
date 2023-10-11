/**
 * FileName: dhcinsu.tarcontrast.audit.js
 * Anchor: tangzf
 * Date: 2020-6-1
 * Description: ҽ��Ŀ¼����Ժ�����
 */
var insudicAuditFlag=""
//�������
$(function(){
	
	init_INSUTarcSearchPanel();
	
	init_dg();
	
	getDicAudit();
});
function init_dg(){
	$HUI.datagrid('#dg',{
		border:false,
		fit:true,
		striped:true,
		pageSize: 50,
		pageList: [50,100],
		data: [],
		toolbar:'#dgTB',
		pagination:true,
		columns:[[
			{field:'ck',checkbox:true},
			{field:'conAddFlag',title:'��˱�־',width:70,
				styler: function(value,row,index){
					var Style = 'color:red;';
					if (value.indexOf( '���ͨ��') > -1){
						Style = 'color:green;';
					}
					return Style;
				}
			},
			{field:'HisCode',title:'�շ������',width:110},
			{field:'HisDesc',title:'�շ�������',width:120},
			{field:'HISSpecification',title:'HIS���',width:65},
			{field:'HISDosage',title:'HIS����',width:65},
			{field:'Price',title:'����',width:60,align:'right',formatter:function(val,data,index){
				val = val || 0; // undefined
				return parseFloat(val).toFixed(2);
			}},
			{field:'Cate',title:'����',width:60},
			{field:'InsuCode',title:'ҽ������',width:110},
			{field:'InsuDesc',title:'ҽ������',width:120},
			{field:'PZWH',title:'HIS��׼�ĺ�',width:95},
			{field:'factory',title:'HIS����',width:95},
			{field:'InsuGG',title:'ҽ�����',width:80},
			{field:'InsuDW',title:'ҽ����λ',width:70},
			{field:'InsuSeltPer',title:'�Ը�����',width:80},
			{field:'DW',title:'��λ',width:65,hidden:true},
			{field:'InsuCate',title:'ҽ������',width:55,hidden:true},
			{field:'InsuClass',title:'��Ŀ�ȼ�',width:55,hidden:true},
			{field:'conActDate',title:'��Ч����',width:55,hidden:true},
			{field:'index',title:'���',width:55,hidden:true},
			{field:'LimitFlag',title:'�ⲿ����',width:55,hidden:true},
			{field:'HISPutInTime',title:'HIS¼��ʱ��',width:75,hidden:true},
			{field:'SubCate',title:'����',width:50,hidden:true},
			{field:'Demo',title:'�շ��ע',width:100,hidden:true},
			{field:'UserDr',title:'������',width:55},
			{field:'ConDate',title:'��������',width:65},
			{field:'ConTime',title:'����ʱ��',width:65},
			{field:'AuditUser',title:'�����',width:55},
			{field:'AuditDate',title:'�������',width:65},
			{field:'AuditTime',title:'���ʱ��',width:65},
			{field:'EndDate',title:'��������',width:65,hidden:true},
			{field:'ConQty',title:'��������',width:55,hidden:true},
			{field:'TarId',title:'TarId',width:60,hidden:true},
			{field:'ConId',title:'ConId',width:10,hidden:true},
			{field:'InsuId',title:'InsuId',width:10,hidden:true}

		]],
        onSelect : function(rowIndex, rowData) {	        
		
        },
        onUnselect: function(rowIndex, rowData) {
        },
        onBeforeLoad:function(param){
	    	//alert(new Date().getSeconds())
	    },
	    onLoadSuccess:function(data){
		   // alert(new Date().getSeconds())
		}
	});	
}
// 4 Ժ�����ͨ��  �� 5 Ժ����˲�ͨ��
function Audit(Flag){
	var checkRow = $('#dg').datagrid('getChecked');
	if(checkRow.length == '0'){
		$.messager.alert('����','û����Ҫ����������','error');
		return;	
	}
	$.messager.confirm('��ʾ','�����ι�����[' + checkRow.length +']�����ݣ��Ƿ�ȷ�ϼ�����',function(r){
		if(r){
			var totalRow = checkRow.length;
			var successRow = 0;
			$.each(checkRow, function(index,row){
				if(row.ConId){
					__audit(index, row, totalRow, successRow, Flag);
				}else{
					$.messager.alert('����','���ղ����ڣ��շ������=' + row.HisCode,'error');	
				}
			})
			LoadDataGrid();	
		}		
	})
}
function __audit(index, row, totalRow, successRow, Flag){

	$.m({
			ClassName: "web.INSUTarContrastCom",
			MethodName: "TarContrastAudit",
			ResultSetType: "array",
			RowId: row.ConId,
			AuditFalg: Flag,
			UserDr: PUBLIC_CONSTANT.SESSION.USERID
		},function(rtn){
			if(rtn=='0'){
				successRow = successRow + 1;		
			}
			if(index == totalRow-1){
				setTimeout(function(){
					var msg = '���ι����:' + totalRow + '������' //�ɹ�:' + successRow +'����ʧ�ܣ�' + (totalRow-successRow) + 'ʧ���������ڼƷ�ҽ����־��ѯ������в鿴��'
					$.messager.alert('��ʾ', msg,'info');						
				},300)
				
			}	
		});
}
//ҽ��Ŀ¼����(HIS) ��ѯ������ʼ��
function init_INSUTarcSearchPanel() { 
	var dicurl = $URL + '?ClassName=web.INSUDicDataCom&QueryName=QueryDic&Type=TariType';	//ArgSpl
	// ҽ������
	$('#insuType').combogrid({  
	    panelWidth:350,   
	    panelHeight:238,  
	    idField:'cCode',   
	    textField:'cDesc', 
      	rownumbers:true,
      	fit: true,
      	pagination: false,
      	editable:false,
      	url:dicurl,
      	toolBar:'#dgTB',
	    columns:[[   
	        {field:'cCode',title:'����',width:60},  
	        {field:'cDesc',title:'����',width:100}
	    ]],
	    loadFilter:function(data){ 
			if (data.rows.length > 0){
				data.rows.splice(data.rows.length - 1, 1); // ��query���ص� ȫ�� ȥ��
			}
			return data;
	    },
	    fitColumns: true,
	    onLoadSuccess:function(data){
			//$('#insuType').combogrid('grid').datagrid('selectRow',0);
		},
		//
		onSelect: function(rowData){
			getDicAudit();
		}
	}); 
	
	var TarConJson=$.cm({
	    ClassName:"web.INSUDicDataCom",
	    QueryName:"QueryDic",
	    ResultSetType:"array",
	    Type:"TarContrastAuditCode",
	    Code:"",
	    HospDr:PUBLIC_CONSTANT.SESSION.HOSPID,
	    ExpStr:'N|'	  //�Ƿ����ȫ��  
	 },false)
	
	//���չ�ϵ
	$('#ConType').combobox({  
	    panelHeight:220, 
	    valueField:'cCode',   
	    textField:'cDesc',
	    editable:false,
	    data: TarConJson,
		onSelect: function(rowData){
			chgStatus(rowData)
			LoadDataGrid();	
		},
		onLoadSuccess:function(data){
			if(data.length > 0)	{
				setValueById('ConType',data[0].cCode);
			}
		}
	}); 
	
	
	// ��Ŀ����
	var TarCateurl = $URL + '?ClassName=web.INSUTarContrastCom&QueryName=GetTarCate&HospDr=' + PUBLIC_CONSTANT.SESSION.HOSPID;	//ArgSpl
	$('#TarCate').combogrid({  
	    panelWidth:350,   
	    panelHeight:260,  
	    idField:'Rowid',   
	    textField:'Desc',
	    editable:false, 
      	rownumbers:true,
      	fit: true,
      	pagination: false,
      	url:TarCateurl,
	    columns:[[   
	        {field:'Rowid',title:'Rowid',width:60},  
	        {field:'Desc',title:'����',width:100}
	    ]],
		fitColumns: true,
		onBeforeLoad:function(){
				
		},
		onLoadSuccess:function(data){
			if(data.rows.length > 0){
				$('#TarCate').combogrid('grid').datagrid('selectRow',0);
			}	
		}
	});
	// ��ѯ����
	$('#QClase').combobox({   
	 	panelHeight:100, 
	    valueField:'Code',   
	    textField:'Desc',
	    editable:false,
	    data: [{
				Code: '1',
				Desc: '��ƴ��',
				selected:true
			},{
				Code: '2',
				Desc: '������'
			},{
				Code: '3',
				Desc: '������'
			}]
	}); 
}
//��ѯHIS��������
function LoadDataGrid(){
	var TarDate = getValueById('TarDate'); // 2019-12-19 �շ������� add by tangzf 
	var ActDate = getValueById('ActDate')
	var PrtFlag = 'N';
	var ExpStr = PrtFlag + '|' + TarDate + '|' + PUBLIC_CONSTANT.SESSION.HOSPID;
	var queryParams = {
		ClassName : 'web.INSUTarContrastCom',
		QueryName : 'DhcTarQuery',
		sKeyWord : $('#KeyWords').val(),
		Class : $('#QClase').combobox('getValue'),
		Type : $('#insuType').combobox('getValue') ,
		ConType : $('#ConType').combobox('getValue'),
		TarCate : $('#TarCate').combobox('getValue')=='0' ? '':$('#TarCate').combobox('getValue'),
		ActDate : ActDate,
		ExpStr : ExpStr	
	}
	
	loadDataGridStore('dg',queryParams);
}
function selectHospCombHandle(){
	$('#insuType').combogrid('grid').datagrid('reload');
	$('#TarCate').combogrid('grid').datagrid('reload');
	//QueryINSUTarInfoNew('InsuCode','2');
	
}
function chgStatus(rowdata){
	getDicAudit();
	if(insudicAuditFlag=="0"){
		$("#btnExport").linkbutton("disable");
		$("#btnUpload").linkbutton("disable");
		return;
	}
	if("1,2,6".indexOf(rowdata.Code) != -1){
		//Ժ������ˡ���������˵Ĳ������޸�
		$("#btnExport").linkbutton("disable");
		$("#btnUpload").linkbutton("disable");
		return;
	}
	//���ͨ���Ŀ��Գ���
	if("0,3,5".indexOf(rowdata.Code) != -1){
		$("#btnExport").linkbutton("enable");
		$("#btnUpload").linkbutton("disable");
	}else{
		$("#btnExport").linkbutton("disable");
		$("#btnUpload").linkbutton("enable");
	}
	
	
}
function getDicAudit(){
	//w ##class(web.INSUDicDataCom).GetDicByCodeAndInd("HISPROPertyZZB","TarContrastAuditFlag",4,2)
	insudicAuditFlag = tkMakeServerCall("web.INSUDicDataCom","GetDicByCodeAndInd","HISPROPerty"+$('#insuType').combobox('getValue'),"TarContrastAuditFlag",4,PUBLIC_CONSTANT.SESSION.HOSPID);
	if(insudicAuditFlag=="0"){
		$("#btnExport").linkbutton("disable");
		$("#btnUpload").linkbutton("disable");
	}
}