/**
 * FileName: checkupdateippbo.js
 * Author: zjb
 * Date: 2023-01-30
 * Description: סԺҽ���˵���ѯ����������
 */

 var OutJson = "";
 var tmpselRow = -1;
//�������
$(function(){
	//�س��¼�    
	key_enter();

	// ��ʾ��Ϣ
    //init_hospital();
	// grid
	init_dg();

	RunQuery();
});
//�������
function init_dg(){
	$HUI.datagrid("#dg", {
		fit: true,
		border: false,
		singleSelect: true,
		//fitColumns: true,
		pageSize: 9999999,
		displayMsg: '',
		toolbar:[],
		columns: [[
			{field: 'btn', title: '�����˵�',width: 70, align: "center",
                formatter: function(value, row, index) {
                    return "<a href=\"#this\" class=\"editcls1\" onClick=\"btnCancel(\'" + row.pboid +"\',\'"+row.AdmType+ "\')\"></a>";
                }
            },
			{title: 'Rowid', field: 'pboid', hidden: true}, 
			{title: '��������', field: 'PatName', width: 100},
			{title: '��������', field: 'AdmTypeDesc', width: 80,
				formatter:function (value, row, index){
					return row.AdmType=="I" ? value : "<font color='#f16e57'>"+ value +"</font>"
				}
			},
			{title: 'ҽ��ID', field: 'PBOARCIMDR', width: 100},
			{title: 'ҽ����', field: 'ARCIMDesc', width: 200,showTip:true},
			{title: '����', field: 'PBOUnitPrice', width: 70,align:'right'},
			{title: '�Ʒ�����', field: 'PBOBillQty', width: 70},
			{title: '�˷�����', field: 'PBORefundQty', width: 70},
			{title: '�ۿ۽��', field: 'PBODiscAmount', width: 70,align:'right'},
			{title: '���˽��', field: 'PBOPayorShare', width: 70,align:'right'},
			{title: '�Էѽ��', field: 'PBOPatientShare', width: 70,align:'right'},
			{title: '�Ʒѽ��', field: 'PBOTotalAmount', width: 100,align:'right'},
			{title: '�˵��Ʒ�״̬', field: 'PBPayedFlag', width: 100},
			{title: 'ִ�м�¼ID', field: 'PBOOrdExecDR', width: 100},
			{title: 'ִ�м�¼�Ʒ�״̬', field: 'OEOREBilled', width: 130},
			{title: 'ִ��״̬', field: 'STATDesc', width: 80}
		
		]],
		onClickRow : function(rowIndex, rowData) {
			
        },
        onUnselect: function(rowIndex, rowData) {
        	//alert(rowIndex+"-"+rowData.itemid)
        },
		onLoadSuccess: function(data) {
			$('.editcls1').linkbutton({iconCls:"icon-write-order", plain: true});
			$(this).treegrid('unselectAll');
		},
		onSelect: function() {
			//loadConfPage();
		},
		onLoadError:function(a){
			//alert(2)
		}
	});
}

//��ѯ
function RunQuery() {
	//var pbodData={total:0,rows:[],curPage: 1};
	//var html='<div class=\"panel-title panel-with-icon\">�˵�</table></div></div><div class=\"panel-icon icon-paper-info\"></div><div class=\"panel-tool\"><a href=\"javascript:void(0)\" class=\"layout-button-left\" style=\"display: none;\"></a></div>';
	//$('.panel-header-gray')[0].innerHTML=html;
	
	$.cm({
		ClassName: "BILL.DC.BL.NewlyIPPBOCtl",
		QueryName: "QueryDHCPBOData",
		pboid:getValueById('pboid'),
		rows:999999
	},function(Data){	
		$('#dg').datagrid('loadData',Data);
	});
}

//�����˵�
function btnCancel(pboid,AdmType)
{
	/* var SelRow = $('#dg').datagrid('getSelected');
	if (SelRow==null)
	{
		$.messager.alert('��ʾ','��ѡ����Ҫɾ����ҽ����ϸ��','info');
		return;
	} */
	if(AdmType!="I")
	{
		$.messager.alert('��ʾ','��סԺ���߲��ɲ�����','info');
		return;
	}
	$.messager.confirm('��ʾ','�Ƿ�ȷ�������˵�ҽ����ϸ��',function(r){
		if(r){
			var rtn = tkMakeServerCall("BILL.DC.BL.NewlyIPPBOCtl","DELPBO",pboid,session['LOGON.USERID']);
			if(rtn.indexOf("^")>=0)
			{
				//var msg=rtn.split('^')[1];
				$.messager.alert('��ʾ','�����˵�ʧ�ܣ�\n'+ rtn,'info');
			}
			else
			{
				$.messager.alert('��ʾ','�����˵��ɹ���','info');
				RunQuery();
			}
		}
	});
}

function ClearGrid(gridid){
	$('#' + gridid).datagrid('loadData',{total:0,rows:[]});
	$('#' + gridid).datagrid('unselectAll');
	$('#' + gridid).datagrid('clearChecked');
}


///�س�
function key_enter() {
	$('#pboid').keyup(function (event) {
		if (event.keyCode == 13) {
			RunQuery();
		}
	});
}
//����
function clear_click() {
	//$('#tQueryPanel').form('clear');
	setValueById('pboid','');
	ClearGrid('dg');
}


