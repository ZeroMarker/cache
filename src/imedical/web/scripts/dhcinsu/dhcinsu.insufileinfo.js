/*
 * FileName:	dhcinsu/dhcinsu.insufileinfo.js
 * User:		YuanDC
 * Date:		2021-01-12
 * MainJS:      dhcinsu.insuservqry.js
 * Description: ������ϸ��ѯ-5204
 */
 $(function () { 
 	/*window.onresize=function(){
    	location.reload();//ҳ�����ˢ��
 	} */
 	//setValueById('fileINSUType',GV.INSUTYPE);
 	//setValueById('fileINSUTypeDesc',GV.INSUTYPEDESC);
 	//setValueById('fileInsuplc_admdvs',GV.INSUPLCADMDVS);
	//setValueById('regSDate',getDefStDate(0));
	//setValueById('regEDate',getDefStDate(1));	
	//setValueById('filepsn_no',GV.PSNNO);
	// ҽ������
	init_fileINSUType();
	//click�¼�
	init_fileClick();
	//��ʼ����Ժ��Ϣ��ѯ��¼dg	
	init_insufiledg(); 
	
	//add Hanzh 20211125 �ǼǺŻس���ѯ�¼�
	$("#patientNo").keydown(function (e) {
		patientNoKeydown(e);
	});
	// �����¼
	//initInsuAdmList();
	initAdmList();
	
});

/**
*��ʼ��click�¼�
*/		
function init_fileClick()
{
	 //��ѯ
	 $("#btnfileQry").click(fileQry_Click);
	 //����
	 $("#btnfileClear").click(fileClear_Click);
	 //����
	 $("#btnfileExport").click(fileExport_Click);
	 $("#tarDesc").keydown(function(e) 
	  { 
	     if (e.keyCode==13)
	        {
	           GetInsufileFilter();
	        }
	   }); 
  
}

/**
*����
*/
function fileExport_Click(){
	
var Header={
	    mdtrt_id:'����ID',
        setl_id:'����ID',
		det_item_fee_sumamt:'�ܽ��',
		pric:'����',
		cnt:'����',
		fulamt_ownpay_amt:'ȫ�Էѽ��',
		preselfpay_amt:'�����Ը����',
		chrgitm_lv:'�շ���Ŀ�ȼ�',
		selfpay_prop:'�Ը�����',
		lmt_used_flag:'����ʹ�ñ�־',
		med_chrgitm_type:'ҽ���շ���Ŀ���',
		hilist_name:'ҽ��Ŀ¼����',
	    hilist_code:'ҽ��Ŀ¼����',
		med_list_codg:'ҽ��Ŀ¼����',
	    medins_list_codg:'ҽҩ����Ŀ¼����',
		medins_list_name:'ҽҩ����Ŀ¼����',
		feedetl_sn:'������ϸ��ˮ��',
		fee_ocur_time:'���÷���ʱ��',
		inscp_scp_amt:'�������߷�Χ���',
	    pric_uplmt_amt:'�������޽��',
		overlmt_amt:'���޼۽��',
		bilg_dept_codg:'�������ұ���',
		bilg_dept_name:'������������',
		bilg_dr_codg:'����ҽ������',
		bilg_dr_name:'����ҽʦ����',
		orders_dr_code:'�ܵ�ҽ������',
		orders_dr_name:'�ܵ�ҽ������',
		acord_dept_codg:'���տ��ұ���',
		acord_dept_name:'���տ�������',
		hosp_appr_flag:'ҽԺ������־',
		chld_medc_flag:'��ͯ��ҩ��־',
	     bas_medn_flag:'����ҩ���־',
		dscg_tkdrug_flag:'��Ժ��ҩ��־',
		list_type:'Ŀ¼���',
		rx_drord_no:'����/ҽ����',
		hi_nego_drug_flag:'ҽ��̸��ҩƷ��־',
		dosform_name:'��������',
		prodname:'δ֪',
		prd_days:'��������',
		etip_hosp_code:'���ҽԺ����',
		opter_name:'����������',
		etip_flag:'����־',
		opt_time:'����ʱ��',
		used_frqu_dscr:'ʹ��Ƶ������',
		spec:'���',
		sin_dos_dscr:'���μ�������',
		tcmdrug_used_way:'��ҩʹ�÷�ʽ',
		prodplac_type:'���������',
		list_sp_item_flag:'Ŀ¼�����־',
		matn_fee_flag:'�������ñ�־',
		drt_reim_flag:'ֱ����־',
		hosp_prep_flag:'ҽԺ�Ƽ���־',
		medc_way_dscr:'��ҩ;������',
		memo:'��ע',
		opter_id:'������ID',
		psn_name:'��Ա����'
		}
    //var data=[{"title":"�ν�","url":"��ɽ","createTime":"1655"},{"title":"������","url":"����ɽ","createTime":"1000"},{"title":"��˽�","url":"����ׯ","createTime":"1000"}]
	var ExcelTool=new INSUExcelTool();
	var rtn=ExcelTool.ExcelExportOfArrData(fileData,Header,"5204��ϸ����");

	}

/**
*����
*/
function fileClear_Click(){
	 $("#fileInfo").form("clear");
	 $("#insufiledg").datagrid({data:[]});
	}
	
/**
*������ϸ��ѯ-5204
*/	
var fileData=[];
function fileQry_Click()
{
	fileData=[];
	var ExpStr=""  
	var filepsnno=getValueById('filepsn_no');
	if(filepsnno == "")
	{
		$.messager.alert("��ܰ��ʾ","��Ա��Ų���Ϊ��!", 'info');
		return ;
	}
	/*var filesetlid=getValueById('filesetl_id');
	if(filesetlid=="")
	{
		$.messager.alert("��ܰ��ʾ","����ID����Ϊ��!", 'info');
		return ;
	}*/
	var filemdtrtid=getValueById('filemdtrt_id');
	if(filemdtrtid=="")
	{
		$.messager.alert("��ܰ��ʾ","����ID����Ϊ��!", 'info');
		return ;
	}
	fileData=getfileInfo();
	//��������û�о���ڵ�
	if(!fileData){return ;}
	if (fileData.length==0){$.messager.alert("��ܰ��ʾ","δ��ѯ����Ӧ�ķ�����ϸ!", 'info');return ;}
	loadQryGrid("insufiledg",fileData);
}




///������ϸ��ѯ-5204
function getfileInfo()
{
	$("#insufiledg").datagrid({data:[]});
	//���ݿ����Ӵ�
	var connURL=""
	//'ExpStr=ҽ������^���״���^����ֵ��ʽ��ʶ()^����ֵ���ݽڵ���^���ݿ����Ӵ�^"ArgName1=ArgValue1&ArgName2=ArgValue2&...&ArgNameN=ArgValueN"
	var ExpStr=getValueById('fileINSUType')+"^"+"5204"+"^^output^"+connURL;
	var QryParams=""
	QryParams=AddQryParam(QryParams,"psn_no",getValueById('filepsn_no'));
	QryParams=AddQryParam(QryParams,"setl_id",getValueById('filesetl_id'));
	QryParams=AddQryParam(QryParams,"mdtrt_id",getValueById('filemdtrt_id'));
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
 * ���˲�������
 */
function GetInsufileFilter()
{
	if (fileData.length==0){
		$.messager.popover({msg:'���Ȳ�ѯ����!',type:'info'});
		return ;
	}
	var newData=fileData;
	if (getValueById("tarDesc")!=""){
	    newData = fileData.filter(function(item,index,array){
		       return item.medins_list_name.indexOf(getValueById("tarDesc"))>=0;
		   })
	}
	$("#insufiledg").datagrid({data:[]});
	loadQryGrid("insufiledg",newData);

}

/*
 * datagrid
 */
function init_insufiledg() {
	var dgColumns = [[
		    {field:'mdtrt_id',title:'����ID',width:120},
		    {field:'setl_id',title:'����ID',width:120},
			{field:'med_type',title:'ҽ�����',width:120,formatter: function(value,row,index){
				var DicType="med_type"+getValueById('fileINSUType');
		     	return GetDicDescByCode(DicType,value);          
			}},
			{field:'det_item_fee_sumamt',title:'�ܽ��',width:120,align:'right'},
			{field:'pric',title:'����',width:100,align:'right'},
			{field:'cnt',title:'����',width:100},
			{field:'fulamt_ownpay_amt',title:'ȫ�Էѽ��',width:120,align:'right'},
			{field:'preselfpay_amt',title:'�����Ը����',width:130,align:'right'},
			{field:'chrgitm_lv',title:'�շ���Ŀ�ȼ�',width:130,formatter: function(value,row,index){
				var DicType="chrgitm_lv"+getValueById('fileINSUType');
		     	return GetDicDescByCode(DicType,value);          
			}},
			{field:'selfpay_prop',title:'�Ը�����',width:130},
			{field:'lmt_used_flag',title:'����ʹ�ñ�־',width:120,formatter: function(value,row,index){
				var DicType="lmt_used_flag"+getValueById('fileINSUType');
		     	return GetDicDescByCode(DicType,value);          
			}},
			{field:'med_chrgitm_type',title:'ҽ���շ���Ŀ���',width:150,formatter: function(value,row,index){
				var DicType="med_chrgitm_type"+getValueById('fileINSUType');
		     	return GetDicDescByCode(DicType,value);          
			}},
			{field:'hilist_name',title:'ҽ��Ŀ¼����',width:150},
			{field:'hilist_code',title:'ҽ��Ŀ¼����',width:150},
			{field:'med_list_codg',title:'ҽ��Ŀ¼����',width:150},
			{field:'medins_list_codg',title:'ҽҩ����Ŀ¼����',width:150},
			{field:'medins_list_name',title:'ҽҩ����Ŀ¼����',width:150},
			{field:'feedetl_sn',title:'������ϸ��ˮ��',width:150},
			{field:'fee_ocur_time',title:'���÷���ʱ��',width:160},
			{field:'inscp_scp_amt',title:'�������߷�Χ���',width:150,align:'right'},
			{field:'pric_uplmt_amt',title:'�������޽��',width:150,align:'right'},
			{field:'overlmt_amt',title:'���޼۽��',width:150,align:'right'},
			{field:'bilg_dept_codg',title:'�������ұ���',width:150},
			{field:'bilg_dept_name',title:'������������',width:150},
			{field:'bilg_dr_codg',title:'����ҽ������',width:150},
			{field:'bilg_dr_name',title:'����ҽʦ����',width:150},
			{field:'orders_dr_code',title:'�ܵ�ҽ������',width:150},
			{field:'orders_dr_name',title:'�ܵ�ҽ������',width:150},
			{field:'acord_dept_codg',title:'���տ��ұ���',width:150},
			{field:'acord_dept_name',title:'���տ�������',width:150},
			{field:'hosp_appr_flag',title:'ҽԺ������־',width:150,formatter: function(value,row,index){
				var DicType="hosp_appr_flag"+getValueById('fileINSUType');
		     	return GetDicDescByCode(DicType,value);          
			}},
			{field:'chld_medc_flag',title:'��ͯ��ҩ��־ ',width:150,formatter: function(value,row,index){
				var DicType="chld_medc_flag"+getValueById('fileINSUType');
		     	return GetDicDescByCode(DicType,value);          
			}},
			{field:'bas_medn_flag',title:'����ҩ���־',width:150,formatter: function(value,row,index){
				var DicType="bas_medn_flag"+getValueById('fileINSUType');
		     	return GetDicDescByCode(DicType,value);          
			}},
			{field:'dscg_tkdrug_flag',title:'��Ժ��ҩ��־',width:150,formatter: function(value,row,index){
				var DicType="dscg_tkdrug_flag"+getValueById('fileINSUType');
		     	return GetDicDescByCode(DicType,value);          
			}},
			{field:'list_type',title:'Ŀ¼���',width:150,formatter: function(value,row,index){
				var DicType="list_type"+getValueById('fileINSUType');
		     	return GetDicDescByCode(DicType,value);          
			}},
			{field:'rx_drord_no',title:'����/ҽ����',width:150},
			{field:'hi_nego_drug_flag',title:'ҽ��̸��ҩƷ��־',width:150,formatter: function(value,row,index){
				return value=="1" ? "��":"��" ;     
			}},
			{field:'dosform_name',title:'��������',width:150},
			{field:'prodname',title:'��Ʒ��',width:150},
			{field:'prd_days',title:'��������',width:150},
			{field:'etip_hosp_code',title:'���ҽԺ����',width:150},
			{field:'payLoc',title:'֧���ص����',width:150,formatter: function(value,row,index){
				var DicType="pay_loc"+getValueById('fileINSUType');
		     	return GetDicDescByCode(DicType,value);          
			}},
			{field:'opter_name',title:'����������',width:150},
			{field:'etip_flag',title:'����־',width:150,formatter: function(value,row,index){
				var DicType="etip_flag"+getValueById('fileINSUType');
		     	return GetDicDescByCode(DicType,value);          
			}},
			{field:'opt_time',title:'����ʱ��',width:150},
			{field:'used_frqu_dscr',title:'ʹ��Ƶ������',width:150},
			{field:'spec',title:'���',width:150},
			{field:'sin_dos_dscr',title:'���μ�������',width:150},
			{field:'tcmdrug_used_way',title:'��ҩʹ�÷�ʽ',width:150},
			{field:'prodplac_type',title:'���������',width:150,formatter: function(value,row,index){
				var DicType="prodplac_type"+getValueById('fileINSUType');
		     	return GetDicDescByCode(DicType,value);          
			}},
			{field:'list_sp_item_flag',title:'Ŀ¼�����־',width:150,formatter: function(value,row,index){
				var DicType="list_sp_item_flag"+getValueById('fileINSUType');
		     	return GetDicDescByCode(DicType,value);          
			}},
			{field:'matn_fee_flag',title:'�������ñ�־',width:150,formatter: function(value,row,index){
				var DicType="matn_fee_flag"+getValueById('fileINSUType');
		     	return GetDicDescByCode(DicType,value);          
			}},
			{field:'drt_reim_flag',title:'ֱ����־',width:150,formatter: function(value,row,index){
				var DicType="drt_reim_flag"+getValueById('fileINSUType');
		     	return GetDicDescByCode(DicType,value);          
			}},
			{field:'hosp_prep_flag',title:'ҽԺ�Ƽ���־',width:150,formatter: function(value,row,index){
				var DicType="hosp_prep_flag"+getValueById('fileINSUType');
		     	return GetDicDescByCode(DicType,value);          
			}},
			{field:'medc_way_dscr',title:'��ҩ;������',width:150},
			{field:'memo',title:'��ע',width:150},
			{field:'opter_id',title:'������ID',width:150},
			{field:'psn_name',title:'��Ա����',width:150},
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
		}
	});
}

/**
* add 20211125 Hanzh
* �ǼǺŻس��¼�
*/
function patientNoKeydown(e) {
	var key = websys_getKey(e);
	if (key == 13) {
		getPatInfo();
	}
}
function getPatInfo() {
	var patientNo = getValueById("patientNo");
	if (patientNo) {
		var expStr = "";
		$.m({
			ClassName: "web.DHCOPCashierIF",
			MethodName: "GetPAPMIByNo",
			PAPMINo: patientNo,
			ExpStr: expStr
		}, function(papmi) {
			if (!papmi) {
				$.messager.popover({msg: "�ǼǺŴ�������������", type: "info"});
				return;
			}
			var admStr = "";
			loadInsuAdmList(papmi);
		});
	}
}
/**
* add 20211125 Hanzh
* ��ʼ��ҽ�������¼
*/
function initAdmList() {
	$HUI.combogrid("#InsuAdmList", {
		panelWidth: 560,
		panelHeight: 200,
		striped: true,
		fitColumns: false,
		editable: false,
		method: 'GET',
		idField: 'inadmId',
		textField: 'admStatus',
		columns: [[{field: 'inadmId', title: "����ID", width: 120},
					{field: 'admStatus', title: '��������', width: 80},
					{field: 'admDate', title: '��������', width: 150,
						formatter: function (value, row, index) {
							if (value) {
								return value + " " + row.admTime;
							}
					}
					},
					{field: 'mdtrtId', title: 'ҽ������ID', width: 100},
					{field: 'admdvs', title: '�α�����', width: 80},
					{field: 'psnNo', title: 'ҽ����', width: 120},
					{field: 'regNo', title: '�ǼǺ�', width: 80,hidden:true}
					
			]],
		onLoadSuccess: function (data) {
			    var admIndexEd=data.total;
                if (admIndexEd>0)
                {
	                var admdg = $('#InsuAdmList').combogrid('grid');	
                    admdg.datagrid('selectRow',0);
	              }
		},
		onLoadError:function(e){
		},
		onSelect: function (index, row) { 
			setValueById("patientNo",row.regNo)         		//�ǼǺ�
			setValueById("filemdtrt_id", row.mdtrtId);         	//����ID 
			setValueById("filepsn_no", row.psnNo);              //ҽ����
            setValueById("fileInsuplc_admdvs",row.admdvs)       //�α�����       
		}
	});
}
// ����ҽ�������б� add 20211125 Hanzh
function loadInsuAdmList(myPapmiId) {
	$('#InsuAdmList').combobox('clear');
	
	var queryParams = {
		ClassName: "DHCINSU.ServQry.Manager",
		QueryName: "FindInsuAdmList",
		type: "GET",
		papmi: myPapmiId,
		hospId: PUBLIC_CONSTANT.SESSION.HOSPID,
		HisType:""
	}
	loadComboGridStore("InsuAdmList", queryParams);
}



/*
 * ҽ������ ��ҽ�������йص� ��������Ҫ�������¼���
 */
function init_fileINSUType(){
	var Options = {
		defaultFlag:'Y'	,
		hospDr:GV.HOSPDR
	}
	INSULoadDicData('fileINSUType','DLLType',Options); 	
	$('#fileINSUType').combobox({
		onSelect:function(rec){
			//init_PsnCertType();
			GV.INSUTYPE=getValueById('fileINSUType');
			GV.INSUTYPEDESC=rec.cDesc;
		},
 
	})	;
	
}