/*
 * FileName:	dhcinsu.opspbalqury.js
 * Creator:		LuJH
 * Date:		2022-10-21
 * Description: ���������޶�ʣ���Ȳ�ѯ-2597
*/
$(function () { 
 	init_INSUType();
	//click�¼�
	init_fileClick();
	//��ʼ����Ժ��Ϣ��ѯ��¼dg	
	init_insufiledg(); 
	
	//�ǼǺŻس���ѯ�¼�
	$("#patientNo").keydown(function (e) {
		patientNoKeydown(e);
	});
});

/**
*����
*/
function fileClear_Click(){
	 $("#fileInfo").form("clear");
	 $("#insufiledg").datagrid({data:[]});
	}
/**
*��ʼ��click�¼�
*/		
function init_fileClick()
{
	 //��ѯ
	 $("#btnfileQry").click(fileQry_Click);
	 //����
	 $("#btnfileClear").click(fileClear_Click);
	 
  
}

/**
* �ǼǺŻس��¼�
*/
function patientNoKeydown(e) {
	var key = websys_getKey(e);
	if (key == 13) {
		var patientNo=$("#patientNo").val();
		if (patientNo!='') {
			if (patientNo.length<10) {
				for (var i=(10-patientNo.length-1); i>=0; i--) {
					patientNo="0"+patientNo;
				}
			}
		}
		$("#patientNo").val(patientNo);
		getPatInfo();
	}
}

/*
*���ݵǼǺŲ�����Ա���
*/
function getPatInfo() {
		var patientNo = getValueById("patientNo");
		if (patientNo) {
			var expStr = "";
			$.m({
				ClassName: "DHCINSU.ServQry.Manager",
				MethodName: "GetInsuIdByPapmiNo",
				papmiNo: patientNo,
				
			}, function(data) {
				
				$("#psn_no").val(data);
				
				
			});
		}
	}
/*
 * ҽ������ ��ҽ�������йص� ��������Ҫ�������¼���
 */
function init_INSUType(){
	var Options = {
		defaultFlag:'Y'	,
		hospDr:GV.HOSPDR
	}
	INSULoadDicData('INSUType','DLLType',Options); 	
	$('#INSUType').combobox({
		onSelect:function(rec){
			//init_PsnCertType();
			GV.INSUTYPE=getValueById('INSUType');
			GV.INSUTYPEDESC=rec.cDesc;
		},
 
	})	;
	
}


/**
*���������޶�ʣ���Ȳ�ѯ-2597
*/	
var fileData=[];
function fileQry_Click(){
	fileData=[];
	var ExpStr=""  
	var psnno=getValueById('psn_no');
	if(psnno == "")
	{
		$.messager.alert("��ܰ��ʾ","��Ա��Ų���Ϊ��!", 'info');
		return ;
	}
	fileData=getfileInfo();
	
	if(!fileData){return ;}
	if (fileData.length==0){$.messager.alert("��ܰ��ʾ","δ��ѯ����Ӧ�ķ�����ϸ!", 'info');return ;}
	loadQryGrid("insufiledg",fileData);
	}



///���������޶�ʣ���Ȳ�ѯ-2597
function getfileInfo()
{
	$("#insufiledg").datagrid({data:[]});
	//���ݿ����Ӵ�
	var connURL=""
	//'ExpStr=ҽ������^���״���^����ֵ��ʽ��ʶ()^����ֵ���ݽڵ���^���ݿ����Ӵ�^"ArgName1=ArgValue1&ArgName2=ArgValue2&...&ArgNameN=ArgValueN"
	var ExpStr=getValueById('INSUType')+"^"+"2597"+"^^output^"+connURL;
	var QryParams=""
	QryParams=AddQryParam(QryParams,"psn_no",getValueById('psn_no'));
	QryParams=AddQryParam(QryParams,"year",getValueById('year'));
	QryParams=AddQryParam(QryParams,"page_num","1");
	QryParams=AddQryParam(QryParams,"page_size","100");
	
	ExpStr=ExpStr+"^"+QryParams
	var rtn=InsuServQry(0,GV.USERID,ExpStr); 
	if (!rtn){return ;}
	if (rtn.split("^")[0]!="0") 
	 {
		$.messager.alert("��ʾ","��ѯʧ��!rtn="+rtn, 'error');
		return ;
	}
	var outPutObj=JSON.parse(rtn.split("^")[1]);
	return outPutObj;
}

function init_insufiledg() {
	var dgColumns = [[
		    {field:'code',title:'״̬��',width:100},
		    {field:'type',title:'״̬����',width:100},
			{field:'message',title:'��ʾ��Ϣ',width:100 },
			{field:'insutype',title:'����',width:120},
			{field:'year',title:'���',width:100},
			{field:'psn_no',title:'��Ա���',width:120},			
			{field:'cum_type_code',title:'�ۼƴ�������',width:130},
			{field:'cum',title:'�޶��ۼ�ֵ',width:100},
			{field:'cum_type_name',title:'�ۼƴ�����������',width:160},
			{field:'total',title:'���޶�',width:100},
			{field:'left',title:'ʣ���޶���',width:100},
			{field:'qfx',title:'����',width:100},
		]];

	// ��ʼ��DataGrid
	$('#insufiledg').datagrid({
	
		fit:true,
		border:false,
		data:[],
		//striped: true,
		singleSelect: true,
		pagination: true,
		rownumbers: false, 
        pageNumber:1,        
		pageSize: 20,
		pageList: [20, 30, 40, 50],
		columns: dgColumns,
		onDblClickRow:function(index,rowData){
			//FindReportInfo();	
		},
		onSelect : function(rowIndex, rowData) {
		}
		
	});
	


	
}
