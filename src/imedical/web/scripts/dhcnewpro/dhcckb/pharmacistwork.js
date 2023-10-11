//===========================================================================================
// Author��      yuliping
// Date:		 2021-05-21
// Description:	 ҩʦ������ͳ��
//===========================================================================================
				
/// ҳ���ʼ������
function initPageDefault(){
	initDateBox()
	initDataGrid();		// ҳ��DataGrid��ʼ������
	initButton();		// ��ť��Ӧ�¼���ʼ��
}
///��ʼ���¼��ؼ�
function initDateBox(){
	$HUI.datebox("#stDate").setValue(formatDate(0));
	$HUI.datebox("#endDate").setValue(formatDate(0));
	
}
function initButton(){

	$("#searchBTN").bind("click",loadDataGrid);	// ���¼���

}

function initDataGrid(){

	var diccolumns=[[ 
			{field:'Operator',title:'ҩʦ����',width:100,hidden:false},
			{field:'Diction',title:'����',width:100,hidden:false},
			{field:'addNum',title:'��������',width:100,align:'left'},
			{field:'editNum',title:'�޸�����',width:100,align:'left'},
			{field:'confirmNum',title:'ȷ������',width:100,align:'left'},
			{field:'allNum',title:'�ϼ�',width:100,align:'left'},
			
			
		 ]]		 
	var option={	
		bordr:false,
		fit:true,
		fitColumns:true,
		singleSelect:true,	
		nowrap: false,
		striped: true, 
		pagination:false,
		rownumbers:true,
		onLoadSuccess: function (data) {
			
			$('#datagrid').datagrid("autoMergeCells",['Operator']);
     
		}
		  
	}

	var stdate = $HUI.datebox("#stDate").getValue()
	var enddate = $HUI.datebox("#endDate").getValue()
	$HUI.datebox("#stdate").setValue
	var uniturl = $URL+"?ClassName=web.DHCCKBComQuery&MethodName=listPharmacistWork&StDate="+stdate+"&EndDate="+enddate;
	new ListComponent('datagrid', diccolumns, uniturl, option).Init();

	
	}
function loadDataGrid(){
	var stdate = $HUI.datebox("#stDate").getValue()
	var enddate = $HUI.datebox("#endDate").getValue()
	
	$('#datagrid').datagrid('load',{
		StDate:stdate,
		EndDate:enddate
	}); 

	}
//�ϲ��еĴ���
$.extend($.fn.datagrid.methods, {
	    autoMergeCells : function (jq, fields) {
	        return jq.each(function () {
	            var target = $(this);
	            if (!fields) {
	                fields = target.datagrid("getColumnFields");
	            }
	            var rows = target.datagrid("getRows");
	            var i = 0,
	            j = 0,
	            temp = {};
	            for (i; i < rows.length; i++) {
	                var row = rows[i];
	                j = 0;
	                for (j; j < fields.length; j++) {
	                    var field = fields[j];
	                    var tf = temp[field];
	                    if (!tf) {
	                        tf = temp[field] = {};
	                        tf[row[field]] = [i];
	                    } else {
	                        var tfv = tf[row[field]];
	                        if (tfv) {
	                            tfv.push(i);
	                        } else {
	                            tfv = tf[row[field]] = [i];
	                        }
	                    }
	                }
	            }
	            $.each(temp, function (field, colunm) {
	                $.each(colunm, function () {
	                    var group = this;
	                    if (group.length > 1) {
	                        var before,
	                        after,
	                        megerIndex = group[0];
	                        for (var i = 0; i < group.length; i++) {
	                            before = group[i];
	                            after = group[i + 1];
	                            if (after && (after - before) == 1) {
	                                continue;
	                            }
	                            var rowspan = before - megerIndex + 1;
	                            if (rowspan > 1) {
	                                target.datagrid('mergeCells', {
	                                    index : megerIndex,
	                                    field : field,
	                                    rowspan : rowspan
	                                });
	                            }
	                            if (after && (after - before) != 1) {
	                                megerIndex = after;
	                            }
	                        }
	                    }
	                });
	            });
	        });
	    }
	});

/// JQuery ��ʼ��ҳ��
$(function(){ initPageDefault(); })
