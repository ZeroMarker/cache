/**
 * FileName: dhcinsu.rptdetailinfo.js
 * Anchor: LuJH
 * Date: 2022-07-12
 * Description: ������ϸ��Ϣ��ѯ-5402
 */
$(function() {
	 init_insufiledg(),
	 init_wdg(),
	 init_edg(),
	 init_fileClick()
	 init_INSUType()
	 var Rq = INSUGetRequest();
	 var psn_no=""
	 var rpotc_no=""
	 var fixmedins_code=""
	 psn_no=Rq["psn_no"];
	 rpotc_no=Rq["rpotc_no"];
	 fixmedins_code=Rq["fixmedins_code"];
	 setValueById('psn_no',psn_no);
	 setValueById('rpotc_no',rpotc_no);
	 setValueById('fixmedins_code',fixmedins_code);
	 if(((psn_no)!=undefined)&((rpotc_no)!="undefined")&((fixmedins_code)!="undefined"))
		{
			fileQry_Click();
			}
	  })
	 

/**
*��ʼ��click�¼�
*/		
function init_fileClick()
{
	 //��ѯ
	 $("#btnFind").click(fileQry_Click);
	

	 
  
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
*������ϸ��Ϣ��ѯ-5402
*/	
var fileData=[];
function fileQry_Click(){
	fileData=[];
	var ExpStr=""  
	var psnNo=getValueById('psn_no');
	var rpotcNo=getValueById('rpotc_no');
	var fixmedinsCode=getValueById('fixmedins_code');
	if(psnNo == "")
	{
		$.messager.alert("��ܰ��ʾ","��Ա��Ų���Ϊ��!", 'info');
		return ;
	}
	if(rpotcNo == "")
	{
		$.messager.alert("��ܰ��ʾ","���浥�Ų���Ϊ��!", 'info');
		return ;
	}
	if(fixmedinsCode == "")
	{
		$.messager.alert("��ܰ��ʾ","������Ų���Ϊ��!", 'info');
		return ;
	}
	fileData=getfileInfo();
	//��������û�о���ڵ�
	if(!fileData){return ;}
	if (fileData.length==0){$.messager.alert("��ܰ��ʾ","δ��ѯ����Ӧ�ķ�����ϸ!", 'info');return ;}
	loadQryGrid("insufiledg",fileData.checkReportDetails);
	}



///������ϸ��Ϣ��ѯ-5402
function getfileInfo(expStr)
{
	$("#dg").datagrid({data:[]});
	//���ݿ����Ӵ�
	var connURL=""
	//'ExpStr=ҽ������^���״���^����ֵ��ʽ��ʶ()^����ֵ���ݽڵ���^���ݿ����Ӵ�^"ArgName1=ArgValue1&ArgName2=ArgValue2&...&ArgNameN=ArgValueN"
	var ExpStr=getValueById('INSUType')+"^"+"5402"+"^^output^"+connURL;
	var QryParams=""
	QryParams=AddQryParam(QryParams,"psn_no",getValueById('psn_no'));
	QryParams=AddQryParam(QryParams,"rpotc_no",getValueById('rpotc_no'));
	QryParams=AddQryParam(QryParams,"fixmedins_code",getValueById('fixmedins_code'));
	QryParams=AddQryParam(QryParams,"insuplc_admdvs",getValueById('fileInsuplc_admdvs'));
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

/*
*��ʼ����鱨����ϸ��Ϣ���
*/
function init_insufiledg() {
		if(psn_no!=""){$('#psn_no').html(psn_no);}
		if(rpotc_no!=""){$('#rpotc_no').html(rpotc_no);}
		if(fixmedins_code!=""){$('#fixmedins_code').html(fixmedins_code);}
	
	var columns=[[
			{field:'psn_no',title:'��Ա���',width:120},
			{field:'rpotc_no',title:'���浥��',width:120},
			{field:'rpt_date',title:'��������',width:120},
			{field:'rpotc_type_code',title:'���浥��',width:120},
			{field:'exam_rpotc_name',title:'��鱨�浥����',width:120},
			{field:'exam_rslt_poit_flag',title:'��������Ա�־',width:120},
			{field:'exam_rslt_abn',title:'����쳣��־',width:120},
			{field:'exam_ccls',title:'������',width:120},
			{field:'bilgDrName',title:'����ҽʦ',width:120}
	]]
	$("#dg").datagrid({
		fit:true,
		border:false,
		data:[],
		singleSelect:true,
		pagination:true,
		rownumbers:false,
		pageNumbers:1,
		pageSize:20,
		pageList:[20,30,40,50],
		columns:columns,
		onDblClickRow:function(index,rowData){
			//FindReportInfo();	
		},
		
		onSelect : function(rowIndex, rowData) {
	        ChangeButtonByPublishStatus();
	        
			Load_wdg_DataGrid();
        },
		})
	}

/*
*��ʼ�����鱨����Ϣ���
*/
function init_wdg() { 
	var wColumns=[[
			{field:'psn_no',title:'��Ա���',width:120},
			{field:'rpotc_no',title:'���浥��',width:80},
			{field:'exam_item_code',title:'����-��Ŀ����',width:100},
			{field:'exam_item_name',title:'����-��Ŀ����',width:100},
			{field:'rpt_date',title:'��������',width:80},
			{field:'rpot_doc',title:'����ҽʦ',width:80}
	
	]]
	$("#wdg").datagrid({
		fit:true,
		border:false,
		data:[],
		toolbar: [],
		singleSelect:true,
		pagination:true,
		rownumbers:false,
		columns:wColumns,
		onDblClickRow:function(index,rowData){
			//FindReportInfo();	
		},
		onSelect : function(rowIndex, rowData) {
	        ChangeButtonByPublishStatus();
			Load_edg_DataGrid();
        }
		})
}

function Load_dg_DataGrid(){
	INSUMIClearGrid('wdg');
	INSUMIClearGrid('edg');
	}

function Load_wdg_DataGrid(){
	INSUMIClearGrid('edg');
	var dgSelect = $('#dg').datagrid('getSelected');
	if(!dgSelect){
		$.messager.alert('��ʾ', '����ѡ�񱨸�','error');
        return ;	
	}
	if(dgSelect.ROWID==""){
		return;
	}
	fileData=getfileInfo();
	//var data=[dgSelect];
	$("#wdg").datagrid('loadData',fileData.inspectionReportInformation);

	
}

/*
*��ʼ��������ϸ��Ϣ���
*/
function init_edg() { 
	var eColumns=[[
			{field:'rpotc_no',title:'���浥��',width:80},
			{field:'exam_mtd',title:'���鷽��',width:80},
			{field:'ref_val',title:'�ο�ֵ',width:80},
			{field:'exam_unt',title:'����-������λ',width:100},
			{field:'exam_rslt_val',title:'����-���(��ֵ)',width:120},
			{field:'exam_rslt_qual',title:'���� - ���(����)',width:120},
			{field:'exam_item_detl_code',title:'���� - ��Ŀ��ϸ����',width:150},
			{field:'exam_item_detl_name',title:'���� - ��Ŀ��ϸ����',width:150},
			{field:'exam_rslt_qual',title:'���� - ���(����)',width:150},
			{field:'exam_rslt_abn',title:'��� / �������쳣��ʶ',width:180}
			
	
	]]
	$("#edg").datagrid({
		fit:true,
		border:false,
		data:[],
		toolbar: [],
		singleSelect:true,
		pagination:true,
		rownumbers:false,
		columns:eColumns,
		onDblClickRow:function(index,rowData){
			//FindReportInfo();	
		}
		})
}


function Load_edg_DataGrid(){
	var wdgSelect = $('#wdg').datagrid('getSelected');
	if(!wdgSelect){
		$.messager.alert('��ʾ', '����ѡ�񱨸�','error');
        return ;	
	}
	if(wdgSelect.ROWID==""){
		return;
	}
	fileData=getfileInfo();
	//var data=[wdgSelect];
	$("#edg").datagrid('loadgrid',fileData.inspectionDetails);
}




