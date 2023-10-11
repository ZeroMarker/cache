/**
 * ���ݺ˲��������Ŀ
 * FileName: dhcbill\dc\unaudititm.js
 * tangzf 2022-05-11
 */
 var GV = {
	CLASSNAME:"BILL.DC.BL.UnAuditItmCtl"	 
}
//ȫ�ֱ���
var selRowid="";
var seldictype = ""; 
var tmpselRow = -1;
var PassWardFlag = "N";
var PublicDataSwitchBox = "";
var defendbypro="Y"; //����Ŀά��Y/����ά��N
//var projectaddshow=false;
$(function(){
	var tableName ="CF_BILL_DC.UnAuditItm"; //"User.INSUTarContrast";
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
		onChange: function(newValue,oldValue){
			if(oldValue!="")
			{
				Querydic();    
			}
			clearform("");
	    },
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
		toolbar: '#toolbar',
		singleSelect: true,
		autoRowHeight:false,
		checkbox:true,
		columns:[[
			{field:'ConfigDesc',title:'��ע',width:150,showTip:true,tipPosition:"top"},
			{field:'CateCode',title:'�������',width:50,hidden:true},
			{field:'CateDesc',title:'��������',width:100,hidden:true},
			{field:'CateDataSrc',title:'�������ݼ���',width:80,hidden:true},
			{field:'ActiveFlag',title:'��˱�־',width:80,
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
			{field:'AuditId',title:'�����'}, 
			{field:'AuditMemo',title:'��˱�ע',width:150},
			{field:'AuditDateTime',title:'���ʱ��',width:100,
				formatter: function(value,row,index){
	                    return row.AuditDate+" "+row.AuditTime;
	            }
			},
			{field:'ConfigValue',title:'����ֵ',width:80},
			{field:'BusinessTypeName',title:'ҵ������',width:80,
				formatter: function(value,row,index){
					var BusinessTypeName=row.BusinessTypeName;
	                if (BusinessTypeName==""){
	                    BusinessTypeName="ȫ��";
	                }
	                return BusinessTypeName;
	            }},
			{field:'IndicatorId',title:'ָ�����',width:50,hidden:true}, //,sortable:true,order:'asc'
			{field:'IndicatorName',title:'ָ������',width:130,
				formatter: function(value,row,index){
					var IndicatorName=row.IndicatorName;
	                if (IndicatorName==""){
	                    IndicatorName="ȫ��";
	                }
	                return IndicatorName;
	            }},
			{field:'CRTER',title:'������'}, 
			{field:'CRTEDATE',title:'����ʱ��',width:100,
				formatter: function(value,row,index){
	                    return row.CRTEDATE+" "+row.CRTETIME;
	            }
			}, // CRTER,CRTEDATE,CRTETIME,UPDTID,UPDTDATE,UPDTTIME
			{field:'UPDTID',title:'������'}, 
			{field:'UPDTDATE',title:'����ʱ��',width:100,
				formatter: function(value,row,index){
	                    return row.UPDTDATE+" "+row.UPDTTIME;
	            }
			},
			{field:'Rowid',title:'Rowid',width:10,hidden:true}

		]],
		pageSize: 30,
		pagination:true,
        onSelect: function(rowIndex, rowData) {
	        if(tmpselRow==rowIndex){
		        clearform("")
		        tmpselRow=-1
		        $(this).datagrid('unselectRow',rowIndex)
		    }else{
			    fillform(rowIndex,rowData)
			    tmpselRow=rowIndex;
			}
            
        },
	});
	
	//�ǼǺŻس���ѯ�¼�
	$("#dicKey").keydown(function (e) {
		var key = websys_getKey(e);
		if (key == 13) {
			Querydic();
		}
	});
	
	$("#btnCopy").popover({
		trigger:'hover',
		content:'��ѡ�е����������Ŀ��ӵ�ѡ��ָ�ꡣ'
	});
	$("#btnAllCopy").popover({
		trigger:'hover',
		content:'��ѡ��ָ���µ�<font color=\'#f16e57\'>����</font>������Ŀ��ӵ�ѡ��ָ�ꡣ'
	});
	$("#btnTip").popover({
		trigger:'hover',
		content:initTipInfo()
	});
	init_BusinessTypeQ();
	init_IndexQ('');
	Querydiccbx();
	init_BusinessTypeIdCB();
	init_CateCode();
	init_ConfigValue();
	init_ActiveFlagCB();
	init_defendbyproQ();
});
function init_defendbyproQ(val){
	$HUI.combobox("#defendbypro", {
		panelHeight: 150,
		valueField: 'Code',
		textField: 'Desc',
		mode:'local',
		data:[{"Code":"Y","Desc":"�����Ŀά��"},{"Code":"N","Desc":"���ݺ˲�ָ��ά��"}],
		editable: false,
		onLoadSuccess: function (data) {
			if (data.length > 0) {
				$(this).combobox("select", data[0].Code);
			}
		},
	    onChange: function(newValue,oldValue){
			oneprojectadd();
	    },

	});
}
//����Ŀά��
function oneprojectadd()
{
 	if($('#defendbypro').combobox('getValue')=="Y")
	{
		defendbypro="Y";
		$(".addproject").hide();
	}
	else
	{
		defendbypro="N";
		$(".addproject").show();
	} 
}
function initTipInfo(){
	var tipinfo="<ul class='tip_class'><li style='font-weight:bold'>�������Ŀ����ʹ��˵��</li>" +
		'<li>1��Ӧ�ó�������ָ��˲�����У�������ĳһ��Ŀ���й��˴����ȿ���ָ��ָ�������ϸ���Ŀ���ﵽ����Ŀ����Ч����</li>' +
		'<li>--------------------------------------------------------------------------------------------------------------------</li>'+
		'<li>2������Ŀά�����������Ŀά��������Ŀ�����浽����ָ�����档</li>' +
		'<li>--------------------------------------------------------------------------------------------------------------------</li>';
	return tipinfo;
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
			param.HospID ="G";
			param.KeyCode="";
			param.PDicType= "BusinessTypeCode";
			param.ResultSetType = 'array';
			return true;
		},
	});
}
function init_BusinessTypeIdCB(){
	$HUI.combobox("#BusinessTypeCode", {
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
				$(this).combobox("select", data[0].DicCode);
			}
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
			param.HospID = "G";
			param.KeyCode="";
			param.PCheckType= "";
			param.QBusinessType= val;//"";
			param.ResultSetType = 'array';
		},
		onLoadSuccess: function (data) {
			if (data.length > 0) {
			}
		},
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
			param.HospID = "";
			param.KeyCode="";
			param.PCheckType= "";
			param.QBusinessType= val;//"";
			param.ResultSetType = 'array';
		},
		onLoadSuccess: function (data) {
			if (data.length > 0) {
			}
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
			param.HospID = 'G';//getValueById("hospital");
			param.ResultSetType = 'array';
			param.KeyCode="";
			param.ExpStr="N||Y";
			param.PDicType="UnAuditType";
		},
		onLoadSuccess: function (data) {
			if (data.length > 0) {
				$(this).combobox("select", data[0].DicCode);
			}
		},
	    onSelect:function(val){
			init_ConfigValue();
			$("#projectvalue")[0].innerHTML="<label class='Redword'>*</label>"+($('#CateCode').combobox("getText"));

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
		mode:"remote",
		onBeforeLoad: function (param) {
			param.ClassName = GV.CLASSNAME;
			param.QueryName = "QueryDHCTarItem";
			param.Key=param.q;
			
			if($('#CateCode').combobox('getValue')=="ArcItm"){
				param.QueryName = "QueryARCItmMast";
			}
			param.HospID = getValueById("hospital");
			param.ResultSetType = 'array';
		},
		onLoadSuccess: function (data) {
		},
	    onSelect:function(val){
		} 
	});
}


function init_ConfigDesc(){
	$HUI.combobox("#ConfigDesc", {
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
		HospID : getValueById("hospital")==""?"2":getValueById("hospital"),
		BusinessType : getValueById('BusinessTypeCodeQ'),
		IndexCode :  getValueById('IndicatorIdQ'),
		CateCode:$('#diccbx').combobox('getValue'),
		ExamineFlag:$('#ExamineFlag').combobox('getValue')
	}
	seldictype=$('#diccbx').combobox('getValue');
	loadDataGridStore('dg',QueryParam);
}

//ͣ�ñ����¼
function StopDic(){
	if(selRowid=="" || selRowid<0 || !selRowid){
		$.messager.alert('��ʾ','��ѡ��Ҫͣ�õ���Ŀ!','info'); 
		return;  
	}
	if(getValueById('ActiveFlag')=="N")
	{
		if($('#dg').datagrid('getRows')[tmpselRow]['AuditId']!="")
		{
			$.messager.alert('��ʾ','��˾ܾ�����Ŀ����Ҫͣ��!','info'); 
		}
		else
		{
			$.messager.alert('��ʾ','δ��˵���Ŀ����Ҫͣ��!','info'); 
		}
		return;
	}
	$.messager.confirm("��ʾ", "�Ƿ�ͣ�ã�", function (r) { // prompt �˴���Ҫ����Ϊ��������
	if (r) {
				var savecode=tkMakeServerCall(GV.CLASSNAME,"Stop",selRowid,session['LOGON.USERID'])
				if(eval(savecode)==0){
					$.messager.alert('��ʾ','ͣ�óɹ�!','info');   
					$("#dg").datagrid('reload')
					selRowid="";
					$("#dg").datagrid("getPager").pagination('refresh');
					$("#dg").datagrid('unselectAll');
				}else{
					$.messager.alert('��ʾ','ͣ��ʧ��!','info');   
				}
			} else {
		return false;
	}
	})

}
//���ñ����¼
function OpenDic(){
	if(selRowid=="" || selRowid<0 || !selRowid){
		$.messager.alert('��ʾ','��ѡ��Ҫ���õ���Ŀ!','info'); 
		return;  
	}
	if(getValueById('ActiveFlag')=="Y")
	{
		$.messager.alert('��ʾ','δͣ�õ���Ŀ����Ҫ����!','info'); 
		return;
	}
	else if(getValueById('ActiveFlag')=="N")
	{
		if($('#dg').datagrid('getRows')[tmpselRow]['AuditMemo']!="ͣ��")
		{
			$.messager.alert('��ʾ','δͣ�õ���Ŀ����Ҫ����!','info'); 
			return;
		}
	}
	$.messager.confirm("��ʾ", "�Ƿ����ã�", function (r) { // prompt �˴���Ҫ����Ϊ��������
	if (r) {
				var savecode=tkMakeServerCall(GV.CLASSNAME,"Open",selRowid,session['LOGON.USERID'])
				if(eval(savecode)==0){
					$.messager.alert('��ʾ','���óɹ�!','info');   
					$("#dg").datagrid('reload')
					selRowid="";
					$("#dg").datagrid("getPager").pagination('refresh');
					$("#dg").datagrid('unselectAll');
				}else{
					$.messager.alert('��ʾ','����ʧ��!','info');   
				}
			} else {
		return false;
	}
	})

}
//�����ַ�����
function SplVCFormat(FStr)
{
	return  FStr.replace(/\^/g,"");
}
//���±����¼
function UpdateDic(){  
	var BusinessTypeCode=getValueById('BusinessTypeCode');
	var ChooseDesc=$("#IndicatorId").combobox('getText');
	var CateCode = getValueById('CateCode');
	var CateDesc = getValueById('CateDesc');
	var CateDataSrc = getValueById('CateDataSrc');
	var ConfigValue = getValueById('ConfigValue');//$("#ConfigValue").combobox('getText');
	var ConfigDesc = $("#ConfigValue").combobox('getText');//getValueById('ConfigDesc');
	var ActiveFlag = "N";//�޸�֮��Ҫ����˺������
	var HospDr = getValueById("hospital");
	var ChooseID=$("#IndicatorId").combobox('getValues');
	if(defendbypro=="Y")//����Ŀά��,ֻ��һ��ΪALL��ָ��
	{
		
		var IndicatorId ="ALL";
		var saveinfo="^"+IndicatorId+"^"+CateCode+"^"+CateDesc+"^"+CateDataSrc+"^"+ConfigValue+"^"+ConfigDesc;
		saveinfo=saveinfo+"^"+ActiveFlag+"^"+HospDr;
		saveinfo=saveinfo.replace(/��������Ϣ/g,"")
		var savecode=tkMakeServerCall(GV.CLASSNAME,"Save",saveinfo,session['LOGON.USERID']);
		if(eval(savecode)>0){
			$("#dg").datagrid('reload');
			$("#dg").datagrid('unselectAll');
			clearform("");
			$.messager.alert('��ʾ','����ɹ�!','info');   
		}else if (savecode='-1'){
			$.messager.alert('��ʾ','����ʧ��:��Ŀ�Ѵ��ڣ���Ŀ��'+ConfigDesc,'info');   
		}
		else {
			$.messager.alert('��ʾ','����ʧ��!rtn=' + savecode,'info');  
		}
		$("#dg").datagrid('reload');
		$("#dg").datagrid('unselectAll');
		clearform("");
		return;
	}
	else if (ChooseID.length===1) 
	{
		var IndicatorId = BusinessTypeCode+'||'+ getValueById('IndicatorId');
		selRowid = selRowid<0?"":selRowid;
		var saveinfo=selRowid+"^"+IndicatorId+"^"+CateCode+"^"+CateDesc+"^"+CateDataSrc+"^"+ConfigValue+"^"+ConfigDesc;
		saveinfo=saveinfo+"^"+ActiveFlag+"^"+HospDr;
		saveinfo=saveinfo.replace(/��������Ϣ/g,"");
		var savecode=tkMakeServerCall(GV.CLASSNAME,"Save",saveinfo,session['LOGON.USERID']);
		if(eval(savecode)>0){
			//$.messager.alert('��ʾ','����ɹ�!');  
			$("#dg").datagrid('reload');
			$("#dg").datagrid('unselectAll');
			clearform("");
			$.messager.alert('��ʾ','����ɹ�!','info');   
		}else if (savecode=='-1'){
			$.messager.alert('��ʾ','����ʧ�ܣ���Ŀ��' + ChooseDesc+'-'+ConfigDesc,'info');   
		}
	}
	else
	{
		var DescList=$("#IndicatorId").combobox('getText').split(',');
		for (var i=0; i<ChooseID.length; i++)
		{
			var IndicatorId = BusinessTypeCode + '||' + ChooseID[i];
			selRowid = selRowid<0?"":selRowid;
			var saveinfo=selRowid+"^"+IndicatorId+"^"+CateCode+"^"+CateDesc+"^"+CateDataSrc+"^"+ConfigValue+"^"+ConfigDesc;
			saveinfo=saveinfo+"^"+ActiveFlag+"^"+HospDr;
			saveinfo=saveinfo.replace(/��������Ϣ/g,"");
			var SuccsessCount=0;
			var FialdCount=0;
			var savecode=tkMakeServerCall(GV.CLASSNAME,"Save",saveinfo,session['LOGON.USERID']);
			if(eval(savecode)>0){
				SuccsessCount+=1; 
			
			}else{
				FialdCount+=1; 
			}
		}
		$.messager.alert('��ʾ','����ɹ�:'+SuccsessCount+"��,ʧ��:"+FialdCount+"��!",'info');   
		$("#dg").datagrid('reload');
		$("#dg").datagrid('unselectAll');
		clearform("");
	}
}
//ɾ����¼
function DelDic(){
	//if(BDPAutDisableFlag('btnDelete')!=true){$.messager.alert('��ʾ','����Ȩ��,����ϵ����Ա��Ȩ!');return;}
	if(selRowid=="" || selRowid<0 || !selRowid){$.messager.alert('��ʾ','��ѡ��Ҫɾ���ļ�¼!','info');return;}
	$.messager.confirm('��ȷ��','��ȷ��Ҫɾ��������¼��?',function(fb){
		if(fb){
			var savecode=tkMakeServerCall(GV.CLASSNAME,"Delete",selRowid)
			if(eval(savecode)==0){
				$.messager.alert('��ʾ','ɾ���ɹ�!','info');   
				$("#dg").datagrid('reload');
				selRowid="";
				$("#dg").datagrid("getPager").pagination('refresh');
				$("#dg").datagrid('unselectAll');
			}else{
				$.messager.alert('��ʾ','ɾ��ʧ��!','info');   
			}
		}else{
			return;	
		}
	});
}
//����±ߵ�form
function fillform(rowIndex,rowData){
	selRowid=rowData.Rowid;
	// IndicatorId,CateCode,CateDesc,CateDataSrc,ConfigValue,ConfigDesc,ActiveFlag,HospDr,CRTER,CRTEDATE,CRTETIME,UPDTID,UPDTDATE,UPDTTIME,Rowid
	if(rowData.IndicatorId.split('||')[0]!="ALL")
	{
		$("#BusinessTypeCode").combobox("select", rowData.IndicatorId.split('||')[0]);
		setValueById('IndicatorId',rowData.IndicatorId.split('||')[1]);
	}
	$("#CateCode").combobox("select",rowData.CateCode);
	setValueById('CateDesc',rowData.CateDesc);
	setValueById('CateDataSrc',rowData.CateDataSrc);
	setValueById('ConfigValue',rowData.ConfigValue);
	setValueById('ConfigDesc',rowData.ConfigDesc);
	setValueById('ActiveFlag',rowData.ActiveFlag);
}
//����±ߵ�form
function clearform(inArgs){
	
	$('.editinfo input').each(function(){        
		$(this).val(inArgs)
	})
	selRowid="";
	setValueById("CateDataSrc","");
	init_BusinessTypeIdCB();
	init_CateCode();
	init_ConfigValue();
	setValueById("ConfigDesc","");
	init_ActiveFlagCB();
}
//�ı��±���ʾ��ı༭״̬
function disinput(tf){
	$('#code').attr("disabled",tf);
	$('#insucode').attr("disabled",tf);
	$('#desc').attr("disabled",tf);
	$('#insudesc').attr("disabled",tf);
	$('#note').attr("disabled",tf);
	$('#note2').attr("disabled",tf);
	
	$('#autFlag').attr("disabled",tf);
	$('#defUserFlag').attr("disabled",tf);
	$('#opIPFlag').attr("disabled",tf);
	$('#userFlag').attr("disabled",tf);
	$('#relUserFlag').attr("disabled",tf);

}
//�������Ŀ�����ֵ䵼��
function Export()
{
   try
   {
	   var KeyCodeValue=getValueById('dicKey')
		$.messager.progress({
	         title: "��ʾ",
			 msg: '���ڵ������'+$('#diccbx').combobox('getText')+'�����ֵ�',
			 text: '������....'
			   });
		$cm({
			ResultSetType:"ExcelPlugin",  
			ExcelName:'���'+$('#diccbx').combobox('getText')+'�����ֵ�',		  
			PageName:"QueryInfo",      
			ClassName: GV.CLASSNAME,
			QueryName: 'QueryUnAuditItm',
			KeyCode: getValueById('dicKey'),
			HospID : getValueById("hospital")==""?"2":getValueById("hospital"),
			BusinessType : getValueById('BusinessTypeCodeQ'),
			IndexCode :  getValueById('IndicatorIdQ'),
			CateCode:$('#diccbx').combobox('getValue'),
			ExamineFlag:$('#ExamineFlag').combobox('getValue')
			
			
		},function(){
			  setTimeout('$.messager.progress("close");', 3 * 1000);	
		});
		
   } catch(e) {
	   $.messager.alert("����",e.message);
	   $.messager.progress('close');
   }; 
}
//zjb 2023/11/11 ԭ���ĵ���ѡ���ļ������ö�״̬������
function Import()
{
	ImportObj.ImportFile(
		{
			FileSuffixname: /^(.xls)|(.xlsx)$/,///^(.txt)$/,
			harset: 'utf-8'
		}, function(arr){
			SaveArr(arr);
		}
	);
}
//ѭ�������淽��
function SaveArr(arr)
{
	var ErrMsg = "";     //��������
    var errRowNums = 0;  //��������
    var sucRowNums = 0;  //����ɹ�������
	var rowCnt=arr.length
	try{
		$.messager.progress({
            title: "��ʾ",
            msg: '����շ�/ҽ����Ŀ�����ֵ䵼��',
            text: '�����У�����'+(rowCnt-1)+'��'
        }); 
		for (i = 1; i < rowCnt; i++) 
		{
			var rowArr=arr[i];
			var IndicatorId = rowArr.IndicatorId?rowArr.IndicatorId:"";
			//var IndicatorName = rowArr.IndicatorName?rowArr.IndicatorName:"";
			var CateCode = rowArr.CateCode?rowArr.CateCode:"";
			var CateDesc = rowArr.CateDesc?rowArr.CateDesc:"";
			var CateDataSrc = rowArr.CateDataSrc?rowArr.CateDataSrc:"";
			var ConfigValue = rowArr.ConfigValue?rowArr.ConfigValue:"";
			var ConfigDesc = rowArr.ConfigDesc?rowArr.ConfigDesc:"";
			var ConfigCODE=rowArr.ConfigCODE?rowArr.ConfigCODE:""; //2023-05-11����ҽ����Ŀ/�շ���Ŀcodeά��	
			var ActiveFlag = rowArr.ActiveFlag?rowArr.ActiveFlag:""; 
			var HospDr = rowArr.HospDr?rowArr.HospDr:"";
			/* var CRTER = rowArr.CRTER?rowArr.CRTER:"";
			var CRTEDATE = rowArr.CRTEDATE?rowArr.CRTEDATE:"";
			var CRTETIME = rowArr.CRTETIME?rowArr.CRTETIME:"";
			var UPDTID = rowArr.UPDTID?rowArr.UPDTID:"";
			var UPDTDATE = rowArr.UPDTDATE?rowArr.UPDTDATE:"";
			var UPDTTIME = rowArr.UPDTTIME?rowArr.UPDTTIME:"";
			var Rowid = rowArr.Rowid?rowArr.Rowid:"";
			var BusinessTypeName = rowArr.BusinessTypeName?rowArr.BusinessTypeName:""; */
			var saveinfo="^"+IndicatorId+"^"+CateCode+"^"+CateDesc+"^"+CateDataSrc+"^"+ConfigValue+"^"+ConfigDesc;
			saveinfo=saveinfo+"^"+ActiveFlag+"^"+HospDr+"^"+ConfigCODE;	
			saveinfo=saveinfo.replace(/��������Ϣ/g,"");
			var savecode=tkMakeServerCall(GV.CLASSNAME,"Save",saveinfo,session['LOGON.USERID']);
            if (savecode == null || savecode == undefined) savecode = -1;
            if (savecode >= 0) {
	        	sucRowNums = sucRowNums + 1;
	        } 
	        else {
		        errRowNums = errRowNums + 1;
		        if (ErrMsg == "") {
			        ErrMsg = i+":"+savecode+"�Ѵ��ڣ�";;
			    }
			    else {
                    ErrMsg = ErrMsg + "<br>" + i+":"+savecode+"�Ѵ��ڣ�";
                }
        	}
		}
		if (ErrMsg == "") {
        	$.messager.progress("close");
        	$.messager.alert('��ʾ', '������ȷ�������');
        } else {
            $.messager.progress("close");
            var tmpErrMsg = "����ɹ���"+sucRowNums +"����ʧ�ܣ�"+errRowNums+"����";
            tmpErrMsg = tmpErrMsg + "<br>ʧ�������кţ�<br>"+ ErrMsg;
            $.messager.alert('��ʾ', tmpErrMsg,'info');
        }
	}
	catch(ex)
	{
		$.messager.progress("close");
		$.messager.alert('��ʾ', '���������쳣��'+ex.message,'error');
	}
}

//�����Ŀ�����ֵ䵼��
function Import2()
{
	var filePath=""
	var exec= '(function tst(){ var xlApp  = new ActiveXObject("Excel.Application");'
	           +'var fName=xlApp.GetOpenFilename("Excel xlsx (*.xlsx), *.xlsx,Excel xls (*.xls), *.xls");'
	           +'if (!fName){fName="";}'
	           +'xlApp.Quit();'
               +'xlSheet=null;'
               +'xlApp=null;'
	           +'return fName;}());'
	  CmdShell.notReturn = 0;
      var rs=CmdShell.EvalJs(exec);
      if(rs.msg == 'success'){
        filePath = rs.rtn;
        importItm(filePath);
      }else{
         $.messager.alert('��ʾ', '���ļ�����'+rs.msg,'error');
      }				   
}
function importItm(filePath)
{
    if (filePath == "") {
        $.messager.alert('��ʾ', '��ѡ���ļ���','info')
        return ;
    }
   $.messager.progress({
         title: "��ʾ",
         msg: '����շ�/ҽ����Ŀ�����ֵ䵼��',
         text: '���ݶ�ȡ��...'
        }); 
   $.ajax({
	async : true,
	complete : function () {
    ReadItmExcel(filePath);
	}
	});
  
}
//��ȡExcel����
function ReadItmExcel(filePath)
{
	
   //��ȡexcel
   var arr;
   try 
   {
	 arr= websys_ReadExcel(filePath);
	 $.messager.progress("close");
	}
   catch(ex)
   {
	  $.messager.progress("close");
	  $.messager.alert('��ʾ', '����websys_ReadExcel�쳣��'+ex.message,'error')
	  return ;
	}
	 var rowCnt=arr.length
	 $.messager.progress({
            title: "��ʾ",
            msg: '����շ�/ҽ����Ŀ�����ֵ䵼��',
            text: '�����У�����'+(rowCnt-1)+'��'
        }); 
	$.ajax({
	   async : true,
	   complete : function () {
       ItmArrSave(arr);
	}
	});
}

//�쳣�����ֵ����ݱ���
function ItmArrSave(arr)
{
	//��ȡ��������
	var ErrMsg = "";     //��������
    var errRowNums = 0;  //��������
    var sucRowNums = 0;  //����ɹ�������
	var rowCnt=arr.length
	 try{
		 for (i = 1; i < rowCnt; i++) 
		 {
			 var rowArr=arr[i]	
			 var IndicatorId = rowArr[0];		 
			 var ChooseDesc=rowArr[1];
			 var CateCode = rowArr[2];
			 var CateDesc = rowArr[3];
			 var CateDataSrc =rowArr[4];
			 var ConfigValue = rowArr[5];
			 var ConfigDesc =rowArr[6];
			 var ActiveFlag = rowArr[7];
			 var HospDr =rowArr[8];
			 var SelRow ="";// rowArr[15];
			 var saveinfo=SelRow+"^"+IndicatorId+"^"+CateCode+"^"+CateDesc+"^"+CateDataSrc+"^"+ConfigValue+"^"+ConfigDesc;
			 saveinfo=saveinfo+"^"+ActiveFlag+"^"+HospDr;
			 saveinfo=saveinfo.replace(/��������Ϣ/g,"");
			 var savecode=tkMakeServerCall(GV.CLASSNAME,"Save",saveinfo,session['LOGON.USERID']);
             if (savecode == null || savecode == undefined) savecode = -1;
             if (savecode >= 0) {
	             sucRowNums = sucRowNums + 1;
	             } 
	        else {
		         errRowNums = errRowNums + 1;
		         if (ErrMsg == "") {
			         ErrMsg = i+":"+savecode;
			         } else {
                            ErrMsg = ErrMsg + "<br>" + i+":"+savecode+"�Ѵ��ڣ�";
                        }
                    }
		 }
		 
		 if (ErrMsg == "") {
                    $.messager.progress("close");
                    $.messager.alert('��ʾ', '������ȷ�������');
                } else {
                   $.messager.progress("close");
                     var tmpErrMsg = "����ɹ���"+sucRowNums +"����ʧ�ܣ�"+errRowNums+"����";
                     tmpErrMsg = tmpErrMsg + "<br>ʧ�������кţ�<br>"+ ErrMsg;
                    $.messager.alert('��ʾ', tmpErrMsg,'info');
                }
		      return ;
		 }
		 catch(ex)
		 {
			  $.messager.progress("close");
			  $.messager.alert('��ʾ', '���������쳣��'+ex.message,'error');
	          return ;
	      }
  return ;
	
}


function Querydiccbx(){
	$HUI.combobox("#diccbx", {
		panelHeight: 150,
		url: $URL,
		editable: false,
		valueField: 'DicCode',
		textField: 'DicDesc',
		onBeforeLoad: function (param) {
			param.ClassName = "BILL.DC.BL.DicDataCtl";
			param.QueryName = "QueryInfo";
			param.HospID = 'G';//getValueById("hospital");
			param.ResultSetType = 'array';
			param.KeyCode="";
			param.ExpStr="N||Y";
			param.PDicType="UnAuditType";
		},
		onLoadSuccess: function (data) {
			if (data.length > 0) {
				$(this).combobox("select", data[0].DicCode);
			}
		},
	    onSelect:function(val){
			Querydic();
			var option = $('#dg').datagrid("getColumnOption", "ConfigDesc")
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
$('.hisui-linkbutton').bind('click',function(){
	 switch (this.id){ 
	    case "btnUpdate" : // ����
	    	var ChooseID=$("#IndicatorId").combobox('getValues');
	    	var CateCode = getValueById('CateCode');
	    	var ConfigValue = $("#ConfigValue").combobox('getText');
			if((ChooseID.length===0||CateCode==""||ConfigValue=="")&&defendbypro=="N")//  //Ĭ������ָ��
			{
				$.messager.alert('��ʾ','���Ǻ�Ϊ����������Ƿ�ѡ��!','info');  
				return false; 
			}
	    	$.messager.confirm("��ʾ", "�Ƿ�������棿", function (r) { // prompt �˴���Ҫ����Ϊ��������
				if (r) {
					UpdateDic();
				} else {
					return false;
				}
			})
	    	break;
	    case "btnDelete" : //ɾ��
			DelDic(); 	
	    	break;
	    case "btnClear" :
	    	clearform();
	    	break;	
	    case "btnStop" : // ͣ��
	    	StopDic();
	    	break;
	    case "btnOpen" : // ����
	    	OpenDic();
	    	break;
	    case "btnClearCho" :
	    	$('#BusinessTypeCodeQ').combobox("select", "");
	    	var defHospId = session['LOGON.HOSPID'];
	    	$('#hospital').combobox('select', defHospId);
	    	$('#ExamineFlag').combobox('select', '');
	    	setValueById('dicKey','');
	    	Querydiccbx();
	    	//$('#IndicatorIdQ').combobox("select", "");
	    	break;
	    default :
	    	break;
	    }
		
}) 
