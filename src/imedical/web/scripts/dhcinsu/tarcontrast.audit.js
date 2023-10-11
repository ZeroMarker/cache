/**
 * FileName: dhcinsu.tarcontrast.audit.js
 * Anchor: tangzf
 * Date: 2020-6-1
 * Description: 医保目录对照院内审核
 */
var insudicAuditFlag=""
//界面入口
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
			{field:'conAddFlag',title:'审核标志',width:70,
				styler: function(value,row,index){
					var Style = 'color:red;';
					if (value.indexOf( '审核通过') > -1){
						Style = 'color:green;';
					}
					return Style;
				}
			},
			{field:'HisCode',title:'收费项代码',width:110},
			{field:'HisDesc',title:'收费项名称',width:120},
			{field:'HISSpecification',title:'HIS规格',width:65},
			{field:'HISDosage',title:'HIS剂型',width:65},
			{field:'Price',title:'单价',width:60,align:'right',formatter:function(val,data,index){
				val = val || 0; // undefined
				return parseFloat(val).toFixed(2);
			}},
			{field:'Cate',title:'大类',width:60},
			{field:'InsuCode',title:'医保编码',width:110},
			{field:'InsuDesc',title:'医保描述',width:120},
			{field:'PZWH',title:'HIS批准文号',width:95},
			{field:'factory',title:'HIS厂家',width:95},
			{field:'InsuGG',title:'医保规格',width:80},
			{field:'InsuDW',title:'医保单位',width:70},
			{field:'InsuSeltPer',title:'自付比例',width:80},
			{field:'DW',title:'单位',width:65,hidden:true},
			{field:'InsuCate',title:'医保大类',width:55,hidden:true},
			{field:'InsuClass',title:'项目等级',width:55,hidden:true},
			{field:'conActDate',title:'生效日期',width:55,hidden:true},
			{field:'index',title:'序号',width:55,hidden:true},
			{field:'LimitFlag',title:'外部代码',width:55,hidden:true},
			{field:'HISPutInTime',title:'HIS录入时间',width:75,hidden:true},
			{field:'SubCate',title:'子类',width:50,hidden:true},
			{field:'Demo',title:'收费项备注',width:100,hidden:true},
			{field:'UserDr',title:'对照人',width:55},
			{field:'ConDate',title:'对照日期',width:65},
			{field:'ConTime',title:'对照时间',width:65},
			{field:'AuditUser',title:'审核人',width:55},
			{field:'AuditDate',title:'审核日期',width:65},
			{field:'AuditTime',title:'审核时间',width:65},
			{field:'EndDate',title:'结束日期',width:65,hidden:true},
			{field:'ConQty',title:'对照数量',width:55,hidden:true},
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
// 4 院内审核通过  ； 5 院内审核不通过
function Audit(Flag){
	var checkRow = $('#dg').datagrid('getChecked');
	if(checkRow.length == '0'){
		$.messager.alert('错误','没有需要操作的数据','error');
		return;	
	}
	$.messager.confirm('提示','您本次共操作[' + checkRow.length +']条数据，是否确认继续？',function(r){
		if(r){
			var totalRow = checkRow.length;
			var successRow = 0;
			$.each(checkRow, function(index,row){
				if(row.ConId){
					__audit(index, row, totalRow, successRow, Flag);
				}else{
					$.messager.alert('错误','对照不存在：收费项代码=' + row.HisCode,'error');	
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
					var msg = '本次共审核:' + totalRow + '条数据' //成功:' + successRow +'条，失败：' + (totalRow-successRow) + '失败数据请在计费医保日志查询界面进行查看。'
					$.messager.alert('提示', msg,'info');						
				},300)
				
			}	
		});
}
//医保目录对照(HIS) 查询条件初始化
function init_INSUTarcSearchPanel() { 
	var dicurl = $URL + '?ClassName=web.INSUDicDataCom&QueryName=QueryDic&Type=TariType';	//ArgSpl
	// 医保类型
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
	        {field:'cCode',title:'代码',width:60},  
	        {field:'cDesc',title:'描述',width:100}
	    ]],
	    loadFilter:function(data){ 
			if (data.rows.length > 0){
				data.rows.splice(data.rows.length - 1, 1); // 把query返回的 全部 去掉
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
	    ExpStr:'N|'	  //是否输出全部  
	 },false)
	
	//对照关系
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
	
	
	// 项目大类
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
	        {field:'Desc',title:'描述',width:100}
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
	// 查询条件
	$('#QClase').combobox({   
	 	panelHeight:100, 
	    valueField:'Code',   
	    textField:'Desc',
	    editable:false,
	    data: [{
				Code: '1',
				Desc: '按拼音',
				selected:true
			},{
				Code: '2',
				Desc: '按代码'
			},{
				Code: '3',
				Desc: '按名称'
			}]
	}); 
}
//查询HIS对照数据
function LoadDataGrid(){
	var TarDate = getValueById('TarDate'); // 2019-12-19 收费项日期 add by tangzf 
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
		//院内已审核、中心已审核的不允许修改
		$("#btnExport").linkbutton("disable");
		$("#btnUpload").linkbutton("disable");
		return;
	}
	//审核通过的可以撤销
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