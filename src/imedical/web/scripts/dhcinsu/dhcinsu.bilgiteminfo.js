
  //FileName dhcinsu.bilgiteminfo.js
//  Anchor LuJH
//  Date 2022-07-12
//  Description ��Ŀ������Ϣ��ѯ-5401
 
$(function () { 
 	init_INSUType();
	//click�¼�
	init_fileClick();
	//��ʼ����Ժ��Ϣ��ѯ��¼dg	
	init_insufiledg(); 
	
	//�ǼǺŻس���ѯ�¼�
	$('#patientNo').keydown(function (e) {
		patientNoKeydown(e);
	});
	
	
});


//����

function fileClear_Click(){
	 $('#fileInfo').form(clear);
	 $('#insufiledg').datagrid({data:[]});
	}

//��ʼ��click�¼�
		
function init_fileClick()
{
	 //��ѯ
	 $('#btnfileQry').click(fileQry_Click);
	 //����
	 $('#btnfileClear').click(fileClear_Click);
	 
  
}


 //�ǼǺŻس��¼�

function patientNoKeydown(e) {
	var key = websys_getKey(e);
	if (key == 13) {
		var patientNo=$('#patientNo').val();
		if (patientNo!='') {
			if (patientNo.length10) {
				for (var i=(10-patientNo.length-1); i=0; i--) {
					patientNo=0+patientNo;
				}
			}
		}
		$('#patientNo').val(patientNo);
		getPatInfo();
	}
}


//���ݵǼǺŲ�����Ա���

function getPatInfo() {
		var patientNo = getValueById(patientNo);
		if (patientNo) {
			var expStr ="" ;
			$.m({
				ClassName: DHCINSU.ServQry.Manager,
				MethodName: GetInsuIdByPapmiNo,
				papmiNo :patientNo,
				
			}, function(data) {
				
				$('#psn_no').val(data);
				
				
			});
		}
	}

 // ҽ������ ��ҽ�������йص� ��������Ҫ�������¼���
 
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



//��Ŀ������Ϣ��ѯ-5401
	
var fileData=[];
function fileQry_Click(){
	fileData=[];
	var ExpStr= ""
	var psnNo=getValueById('psn_no');
	if(psnNo == "")
	{
		$.messager.alert("��ܰ��ʾ","��Ա��Ų���Ϊ��!", 'info');
		return ;
	}
	fileData=getfileInfo();
	//��������û�о���ڵ�
	if(!fileData){return ;}
	if (fileData.length==0){$.messager.alert('��ܰ��ʾ,δ��ѯ����Ӧ�ķ�����ϸ!', 'info');return ;}
	loadQryGrid(insufiledg,fileData);
	}



//��Ŀ������Ϣ��ѯ-5401
function getfileInfo()
{
	$('#insufiledg').datagrid({data:[]});
	//���ݿ����Ӵ�
	var connURL=""
	//ExpStr=ҽ������^���״���^����ֵ��ʽ��ʶ()^����ֵ���ݽڵ���^���ݿ����Ӵ�^ArgName1=ArgValue1&ArgName2=ArgValue2&...&ArgNameN=ArgValueN
	var ExpStr=getValueById('INSUType')+"^"+5401+"^^output^"+connURL;
	var QryParams=""
	QryParams=AddQryParam(QryParams,psn_no,getValueById('psn_no'));
	QryParams=AddQryParam(QryParams,"exam_org_code",getValueById('filesetl_id'));
	QryParams=AddQryParam(QryParams,"exam_org_name",getValueById('exam_org_name'));
	QryParams=AddQryParam(QryParams,"exam_item_code",getValueById('exam_item_code'));
	QryParams=AddQryParam(QryParams,"exam_item_name",getValueById('exam_item_name'));
	QryParams=AddQryParam(QryParams,"insuplc_admdvs",getValueById('fileInsuplc_admdvs'));
	ExpStr=ExpStr+"^"+QryParams
	var rtn=InsuServQry(0,GV.USERID,ExpStr); 
	if (!rtn){return ;}
	if (rtn.split("^")[0]!=0) 
	 {
		$.messager.alert("��ʾ,��ѯʧ��!rtn="+rtn, 'error');
		return ;
	}
	var outPutObj=JSON.parse(rtn.split("^")[1]);
	return outPutObj;
}


//��ʼ�����

function init_insufiledg() {
	var dgColumns = [[
		    {field:'psn_no',title:'��Ա���',width:100},
		    {field:'rpotc_no',title:'���浥��',width:100},
			{field:'rpt_date',title:'��������',width:100 },
			{field:'rpotc_type_code',title:'���浥������',width:120},
			{field:'fixmedins_code',title:'�������',width:100},
			{field:'exam_rpotc_name',title:'��鱨�浥����',width:120},
			
			{field:'exam_rslt_poit_flag',title:'��������Ա�־',width:130},
			{field:'exam_rslt_abn',title:'���������쳣��־',width:160},
			{field:'examCcls',title:'������',width:100},
			
		]];
	var psn_no=getValueById('psn_no');
	var rpotc_no=getValueById('rpotc_no');
	var fixmedins_code=getValueById('fixmedins_code');
	 //��ʼ��DataGrid
	$('#insufiledg').datagrid({
	
		fit:true,
		border:false,
		data:[],
		striped: true,
		singleSelect :true,
		pagination: true,
		rownumbers: false, 
        pageNumber:1,        
		pageSize :20,
		pageList: [20, 30, 40, 50],
		columns: dgColumns,
		onDblClickRow :function(index,rowData){
			//FindReportInfo();	
		},
		onSelect  :function(rowIndex, rowData) {
			var psn_no=rowData.psn_no;
			var rpotc_no=rowData.rpotc_no;
			var fixmedins_code=rowData.fixmedins_code;
	      	var url = "dhcinsu.rptdetailinfo.csp?&classname="+""+"&methodname="+"&psn_no="+psn_no+"&rpotc_no="+rpotc_no+"&fixmedins_code="+fixmedins_code; 
	
	websys_showModal({
		url: url,
		title: "������Ϣ��ѯ",
		iconCls: "icon-w-edit",
		
		
	});
        },
		
	});
	
loadQryGrid('insufiledg',[{psn_no:1,rpotc_no:1,fixmedins_code:1}]);

	
}
