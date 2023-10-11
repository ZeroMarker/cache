/**
 * FileName: checkupdateippbo.js
 * Author: zjb
 * Date: 2023-01-30
 * Description: 住院医嘱账单查询及重新生成
 */

 var OutJson = "";
 var tmpselRow = -1;
//界面入口
$(function(){
	//回车事件    
	key_enter();

	// 提示信息
    //init_hospital();
	// grid
	init_dg();

	RunQuery();
});
//数据面板
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
			{field: 'btn', title: '重新账单',width: 70, align: "center",
                formatter: function(value, row, index) {
                    return "<a href=\"#this\" class=\"editcls1\" onClick=\"btnCancel(\'" + row.pboid +"\',\'"+row.AdmType+ "\')\"></a>";
                }
            },
			{title: 'Rowid', field: 'pboid', hidden: true}, 
			{title: '患者姓名', field: 'PatName', width: 100},
			{title: '就诊类型', field: 'AdmTypeDesc', width: 80,
				formatter:function (value, row, index){
					return row.AdmType=="I" ? value : "<font color='#f16e57'>"+ value +"</font>"
				}
			},
			{title: '医嘱ID', field: 'PBOARCIMDR', width: 100},
			{title: '医嘱项', field: 'ARCIMDesc', width: 200,showTip:true},
			{title: '单价', field: 'PBOUnitPrice', width: 70,align:'right'},
			{title: '计费数量', field: 'PBOBillQty', width: 70},
			{title: '退费数量', field: 'PBORefundQty', width: 70},
			{title: '折扣金额', field: 'PBODiscAmount', width: 70,align:'right'},
			{title: '记账金额', field: 'PBOPayorShare', width: 70,align:'right'},
			{title: '自费金额', field: 'PBOPatientShare', width: 70,align:'right'},
			{title: '计费金额', field: 'PBOTotalAmount', width: 100,align:'right'},
			{title: '账单计费状态', field: 'PBPayedFlag', width: 100},
			{title: '执行记录ID', field: 'PBOOrdExecDR', width: 100},
			{title: '执行记录计费状态', field: 'OEOREBilled', width: 130},
			{title: '执行状态', field: 'STATDesc', width: 80}
		
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

//查询
function RunQuery() {
	//var pbodData={total:0,rows:[],curPage: 1};
	//var html='<div class=\"panel-title panel-with-icon\">账单</table></div></div><div class=\"panel-icon icon-paper-info\"></div><div class=\"panel-tool\"><a href=\"javascript:void(0)\" class=\"layout-button-left\" style=\"display: none;\"></a></div>';
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

//重新账单
function btnCancel(pboid,AdmType)
{
	/* var SelRow = $('#dg').datagrid('getSelected');
	if (SelRow==null)
	{
		$.messager.alert('提示','请选择需要删除的医嘱明细。','info');
		return;
	} */
	if(AdmType!="I")
	{
		$.messager.alert('提示','非住院患者不可操作。','info');
		return;
	}
	$.messager.confirm('提示','是否确认重新账单医嘱明细？',function(r){
		if(r){
			var rtn = tkMakeServerCall("BILL.DC.BL.NewlyIPPBOCtl","DELPBO",pboid,session['LOGON.USERID']);
			if(rtn.indexOf("^")>=0)
			{
				//var msg=rtn.split('^')[1];
				$.messager.alert('提示','重新账单失败：\n'+ rtn,'info');
			}
			else
			{
				$.messager.alert('提示','重新账单成功。','info');
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


///回车
function key_enter() {
	$('#pboid').keyup(function (event) {
		if (event.keyCode == 13) {
			RunQuery();
		}
	});
}
//清屏
function clear_click() {
	//$('#tQueryPanel').form('clear');
	setValueById('pboid','');
	ClearGrid('dg');
}


