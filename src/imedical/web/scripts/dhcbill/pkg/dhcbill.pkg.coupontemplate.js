/*
 * FileName:	dhcbill.pkg.coupontemplate.js
 * User:		tangzf
 * Date:		2019-09-11
 * Function:	
 * Description: �Ż�ȯģ��ά��
 */
 var GV={
	 editRowIndex:-1
}
 $(function () {
	init_dg(); 

	// ���������dg
	init_ProductDg();
	
	setValueById('SearchCtpStartDate',getDefStDate(-31));
	setValueById('SearchCtpEndDate',getDefStDate(31));
	PKGLoadDicData('SearchCtpStatus','CouponTemplate','','combobox');
	
	init_addTemplateDialog();
	$('#SearchCtpCode').keydown(function (e) {
		var key = websys_getKey(e);
			if (key == 13) {
				initLoadGrid();
			}
	})
});
/*
 * �Ż�ȯģ��ά������datagrid
 */
function init_dg() {
	var dgColumns = [[
			{field:'Code',title:'�Ż�ȯ����',width:150},
			{field:'Desc',title:'�Ż�ȯ����',width:150 },
			{field:'VisStrDate',title:'��Ч��ʼ����',width:150},
			{field:'VisEntDate',title:'��Ч��������',width:220},
			{field:'CTPFlag',title:'״̬',width:150,
				styler:function(value,row,index){
					return value=='��Ч'?'color:green;font-weight:bold':'color:red;font-weight:bold'
				},
				editor:{
					type:'combobox',
					options:{
						valueField:'Code',
						textField:'Desc',
						url:$URL,
						editable:false,
						onBeforeLoad:function(param){
							param.ClassName='BILL.PKG.BL.Dictionaries';
							param.QueryName='QueryDic';
							param.ResultSetType='Array';
							param.DictType='CouponTemplate';
							param.DicCode='';
							param.HospDr=PUBLIC_CONSTANT.SESSION.HOSPID;
						}		
		
					}		
				}
			},
			{field:'CreatDate',title:'��������',width:150},
			{field:'CreatTime',title:'����ʱ��',width:120},
			{field:'CreatUser',title:'������',width:150},
			{field:'Hospital',title:'Ժ��',width:150},
			{field:'CTPInstruc',title:'��Ʒ˵��',width:150,hidden:true },
			{field:'CTPRowId',title:'CTPRowId',width:150,hidden:true },
		]];
	$('#dg').datagrid({
		fit: true,
		border: false,
		striped: true,
		singleSelect: true,
		pagination: true,
		rownumbers: true,
		data:[],
		columns: dgColumns,
		frozenColumns: [[
							{
								title: '��Ʒ��Ϣ', field: 'ProductInfo', width:100,align:'center',
								formatter:function(value, row, index){
									return "<a href='#' onmouseover='showProPanel("+JSON.stringify(row)+")' onMouseOut='closeProPanel()' \
									onclick='showProWindow("+JSON.stringify(row)+")'><img style='padding-left:7px;' src='../scripts_lib/hisui-0.1.0/dist/css/icons/template.png ' border=0/>\
									</a>";
								}
							}
						]],
		onLoadSuccess: function (data) {
			GV.editRowIndex = -1;
		},
		onSelect:function(index,row){
			datagridEditRow(index);
		}
	});
}
/*
* ����dg
*/
function initLoadGrid(){
	var queryParams={
		ClassName:'BILL.PKG.BL.CouponTemplate',
		QueryName:'FindCouponTemplate',
		KeyCode:getValueById('SearchCtpCode'),
		StDate:getValueById('SearchCtpStartDate'),
		EntDate:getValueById('SearchCtpEndDate'),
		Flag:getValueById('SearchCtpStatus'),
		HospDr:PUBLIC_CONSTANT.SESSION.HOSPID
	}
	loadDataGridStore('dg',queryParams);	
}
/*
 * ����
 */
$('#BtnFind').bind('click', function () {
	initLoadGrid();
});
/*
 * ����
 */
$('#BtnClear').bind('click', function () {
	window.location.reload(true);	
})
/*
 * ����ģ����Ϣ
 */
$('#BtnAdd').bind('click', function () {
		//
	$('#CouponTemplateWin').show(); 
	$HUI.dialog("#CouponTemplateWin",{
			title:"�Ż�ȯģ��ά��",
			height:460,
			width:770,
			collapsible:false,
			modal:true,
		    iconCls: 'icon-w-edit'
	})
	$("#addInfo").form("clear");
	$('#CtpStatus').combobox('select','1');

});
/*
 * �޸�ģ����Ϣ
 */
$('#BtnUpdate').bind('click', function () {
	if(GV.editRowIndex=='-1'){
		$.messager.alert('��ʾ','����ѡ��Ҫ�޸ĵ�����','info');
		return;
	}else{
		$('#dg').datagrid('acceptChanges');
		var selected = $('#dg').datagrid('getSelected');
		var RowId=selected.CTPRowId;
		var Guser=PUBLIC_CONSTANT.SESSION.USERID;
		var Status=selected.CTPFlag;
		if(isNaN(Status)){
			$.messager.alert('��ʾ','û��Ҫ�޸ĵ�����','info');
			return;
		}
		$.m({
			ClassName: "BILL.PKG.BL.CouponTemplate",
			MethodName: "CouponTmpConProUpdate",
			RowId: RowId,
			Status:Status,
			Guser:Guser
			}, function(rtn){
				if(rtn.split('^')[0]=='0'){
					$.messager.alert('��ʾ', "�޸ĳɹ�", 'info');
					initLoadGrid();	
				}else{
					$.messager.alert('��ʾ', "�޸�ʧ�ܣ�������룺" + rtn.split('^')[1], 'error');	
			}
	});
	}
});
/*
 * ģ����Ϣ�����еı���
 */
$('#PanelBtnSave').bind('click', function () {
	var CtpCode=getValueById('CtpCode');
	if(CtpCode==''){
			$.messager.alert('��ʾ', "�Ż�ȯ���벻��Ϊ��", 'info');	
			return;
	}
	
	var CtpDesc="^"+getValueById('CtpDesc');
	if(getValueById('CtpDesc')==''){
			$.messager.alert('��ʾ', "�Ż�ȯ��������Ϊ��", 'info');	
			return;
	}
	var CtpValidStartDate="^"+getValueById('CtpValidStartDate');
	var CtpValidEndDate="^"+getValueById('CtpValidEndDate');
	var CtpStatus="^"+getValueById('CtpStatus');
	if(getValueById('CtpStatus')==''){
			$.messager.alert('��ʾ', "�Ż�ȯ״̬����Ϊ��", 'info');	
			return;
	}
	var rtn=tkMakeServerCall('BILL.PKG.BL.CouponTemplate','CheckCouponTemplateRepeat',CtpCode);
	if(rtn!=0){
		$.messager.alert('��ʾ', "�Ż�ȯ�����Ѿ�����", 'info');	
		return
	}
	var CtpCreateDate="^"+'';
	var CtpCreateTime="^"+'';
	var CtpCreateuser="^"+PUBLIC_CONSTANT.SESSION.USERID;
	var CtpUpdateDate="^"+'';
	var CtpUodateTime="^"+'';
	var CtpUpdateuser="^"+'';
	var CtpHospitalid="^"+PUBLIC_CONSTANT.SESSION.HOSPID;
	var CtpMark="^"+getValueById('CtpMark');
	var CtpInstruc="^"+getValueById('CtpInstruc');
	var CtpHospTel="^"+getValueById('CtpHospTel');
	var CtpHospAdr="^"+getValueById('CtpHospAdr');
	var CtpHospTra="^"+getValueById('CtpHospTra');
	var CtpExt01="^"+getValueById('CtpExt01');
	var CtpExt02="^"+getValueById('CtpExt02');
	var CtpExt03="^"+getValueById('CtpExt03');
	// Rowid^�Ż�ȯ����^�Ż�ȯ����^��������^����ʱ��^�޸�����^�޸�ʱ��^������^�޸���^��ע^ҽԺID^��Ч��ʼ����^��Ч��������^״̬^ʹ��˵��^�绰^��ַ^Ժѵ^��չ01^��չ02^��չ03
	var Instring="^"+CtpCode+CtpDesc+CtpCreateDate+CtpCreateTime;
	Instring = Instring+CtpUpdateDate+CtpUodateTime+CtpCreateuser +CtpUpdateuser+CtpMark+CtpHospitalid+CtpValidStartDate+CtpValidEndDate+CtpStatus;
	Instring=Instring+CtpInstruc+CtpHospTel+CtpHospAdr+CtpHospTra+CtpExt01+CtpExt02+CtpExt03;
	$.m({
		ClassName: "BILL.PKG.BL.CouponTemplate",
		MethodName: "Save",
		InStr: Instring,
	}, function(rtn){
		if(rtn.split('^')[0]=='0'){
			$.messager.alert('��ʾ', "����ɹ�", 'info');	
		}else{
			$.messager.alert('��ʾ', "����ʧ�ܣ�������룺" + rtn.split('^')[1], 'error');	
		}
		$HUI.dialog("#CouponTemplateWin",'close');
		setValueById('SearchCtpCode',CtpCode);
		initLoadGrid();
	});
	
	
		
});

/*
 * �Ż�ȯģ���Ʒά������ (div)
 */
function showProWindow(rowData){
	var url = "dhcbill.pkg.coupontmpconpro.csp?templateId="+rowData.CTPRowId+'&templateCode='+rowData.Code+'&HOSPITAL='+PUBLIC_CONSTANT.SESSION.HOSPID;
	websys_showModal({
		url: url,
		title: "�Ż�ȯģ���Ʒά��",
		iconCls: "icon-w-edit",
		width: "80%",
		height: "75%",
	});	
}
/*
 * ���������ʾ��Ʒ��Ϣ
 * ---------Start----------  
 */
function showProPanel(rowData){
	return;
	$('#ProInfo').window({
		width:710,
		height:670,
		title:'�ײͼ��',
		iconCls: "icon-w-list",
	})
	add_ProTableData(rowData); //��Ʒ�б� 
	setValueById('mouseCtpDesc',rowData.Desc);
	setValueById('mouseCtpCode',rowData.Code);
	
	
}
function init_ProductDg(){
	var dgColumns = [[
			{field:'PROCode',title:'��Ʒ����',width:100},
			{field:'PROName',title:'��Ʒ����',width:120 },
			{field:'PROSalesPrice',title:'�ۼ�',width:90,align:'right',
				formatter:function(value,index,row){
					return	parseFloat(value).toFixed(2);
				}},
			{field:'PROPrice',title:'��׼����',width:90,align:'right',
				formatter:function(value,index,row){
					return	parseFloat(value).toFixed(2);
				}},
			{field:'PROMimuamout',title:'����ۼ�',width:90,align:'right',
				formatter:function(value,index,row){
					return	parseFloat(value).toFixed(2);
				}},
			{field:'PROStartDate',title:'��Ч����',width:100},
			{field:'PROLevel',title:'�ȼ�',width:50},
			{field:'Rowid',title:'Rowid',width:150,hidden:true}
		]];
	$('#ProTable').datagrid({
		height:540,
		title:'��Ʒ��Ϣ',
		headerCls:'panel-header-gray',
		border: true,
		striped: true,
		singleSelect: false,
		selectOnCheck: true,
		checkOnSelect: true,
		rownumbers: true,
		columns: dgColumns,
		onLoadSuccess: function (data) {
			calProAmt(data);	
		},
		onDblClickRow:function(rowIndex, rowData){
		}
	});
		
}
function add_ProTableData(rowData){			
	var queryParams={
			ClassName:'BILL.PKG.BL.CouponTemplate',
			QueryName:'FindCouponProductByCode',
			CTPCode:rowData.Code,
			HospDr:PUBLIC_CONSTANT.SESSION.HOSPID
	}
	loadDataGridStore('ProTable',queryParams);
}
function closeProPanel(){
	//$('#ProInfo').window('close');
}
/*
 * ���������ʾ��Ʒ��Ϣ
 *
 * ---------End----------  
 */
function INSUCheckStr(InArgStr,InArgName,specialKey) {
    try {
	    if(!specialKey){specialKey="\^\'\"";}
	    if(!InArgName){InArgName="�����";}
        var ErrMsg="";
		var isFlag="";
		for (var i = 0; i < InArgStr.length; i++) {
      		if(specialKey.indexOf(InArgStr.substr(i, 1))>=0)
      		{
	      	isFlag="1";
	   		} 
   	 	} 
    	if (isFlag=="1") {
	    	ErrMsg="��"+InArgName+"��"+"��������"+"\^" +"  "+"\'"+"  "+"\""+" ���ַ�" ;
	    	$.messager.alert('��ʾ',ErrMsg,'info');
	    	return ErrMsg;
    	}else{
	    	return '';	
	    }
    } catch (error) {
        $.messager.alert('��ʾ','dhcbill.pkg.coupontemplate.js�з���:INSUCheckStr()��������:' + error,'info');
    }
    
}
/*
 * ��������������ܽ��
 */
function calProAmt(data){
	var ProAmt=0
	if (data.total>0){
		$.each(data.rows, function (index, row) {
			ProAmt=ProAmt+parseFloat(row.PROSalesPrice);
		});	
	}
	setValueById('mouseCtpPrice',parseFloat(ProAmt).toFixed(2));
}
/*
 * ����ά����Ϣdialog����
 */
function init_addTemplateDialog()
{
	setValueById('CtpValidStartDate',getDefStDate(0));
	setValueById('CtpValidEndDate',getDefStDate(31));
	// �Ż�ȯ״̬combobox
	PKGLoadDicData('CtpStatus','CouponTemplate','','combobox');
	//�����ַ���֤
	$('#CouponTemplatePan .textbox').blur(function (e) {
			var rtn=INSUCheckStr(this.value);
			if(rtn!=''){
				this.value='';
			}
	});		
}
 /*
 * datagrid ��ʼ��һ�б༭��������һ�б༭
 * index ��Ҫ�༭���к�
 */ 
function datagridEditRow(index){
	var tmpEditRowIndex=GV.editRowIndex;
	if(GV.editRowIndex!=-1){
		$('#dg').datagrid('endEdit',GV.editRowIndex);	
	}
	if(tmpEditRowIndex!=index){	// �ظ�ѡ��ȡ���༭	
		GV.editRowIndex=index;
		$('#dg').datagrid('beginEdit',GV.editRowIndex);	
	}	
}
// Ժ��combogridѡ���¼�
function selectHospCombHandle(){
	initLoadGrid();
}