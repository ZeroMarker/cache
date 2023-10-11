$(function(){
	Init();
});

function Init(){
	InitDataGrid();	
}
function InitDataGrid(){
	var columns=[[
        {field: 'OrderSum', title: unescape('�ܼ�'), width: 80, align: 'left'}
        ,{field: 'Price', title: '����', width: 80, align: 'left'}
        ,{field: 'Priority', title: 'ҽ������', width: 90, align: 'left'}
        ,{field: 'Desc', title: 'ҽ������', width: 250, align: 'left',
        	styler: function(value,row,index){
				if (row.OEItemID == ServerObj.ordRowId){
					return 'background-color:red;color:#fff;';
				}
			}
		}
        ,{field: 'PackQty', title: '����', width: 80, align: 'left'}
        ,{field: 'ReLoc', title: '���տ���', width: 150, align: 'left'}
        ,{field: 'Doctor', title: 'ҽʦ', width: 100, align: 'left'}
        ,{field: 'OrdStatus', title: 'ҽ��״̬', width: 100, align: 'left'}
        ,{field: 'OrdStartDate', title: '��ʼʱ��', width: 150, align: 'left'}
        ,{field: 'OrdBilled', title: '�Ʒ�״̬', width: 100, align: 'left'}
        ,{field: 'OrdXDate', title: 'ֹͣ����', width: 100, align: 'left',sortable: true}
        ,{field: 'OrdXTime', title: 'ֹͣʱ��', width: 100, align: 'left',sortable: true}
        ,{field: 'StopDoc', title: 'ͣҽ����', width: 100, align: 'left',sortable: true}
        ,{field: 'OEItemID', title: 'ҽ������', width: 100, align: 'left',sortable: true}
    ]];
    
    var cureDataGrid=$('#tabCureDataList').datagrid({
        fit : true,
        width : 'auto',
        border : false,
        striped : true,
        singleSelect : true,
        fitColumns : false,
        autoRowHeight : true,
        url : $URL,
        loadMsg : '������..',  
        pagination : true,
        showPageList : false,
        pageSize:9999,
		pageList : [9999], 
        rownumbers : true,
        idField:"OEItemID",
        columns :columns,
        rowStyler: function(index,row){
            if (row.OrdStatus=="ֹͣ"){
                return 'background-color:#BDBEC2;color:#000000;';
            }else if (row.OEItemID!=""){
                return '';
            }else{
                return 'background-color:#C8FEC0;color:#000000;';
            }
        },
        queryParams:{
	    	ClassName:"web.DHCDocOPOrdInfo",
	    	QueryName:"GetOrdByAdm" 
	    },
        onBeforeLoad:function(param){
            $.extend(param,{EpisodeID:ServerObj.EpisodeID,SelOrderList:ServerObj.ordRowId,OrdComStatus:"ALL"})
        }
        ,onLoadSuccess:function(data){ 
        	var totalPrice=0;
        	$.each(data.rows,function(i,n){
	        	var OrderSum=n.OrderSum==""?0:n.OrderSum;
	        	totalPrice+=parseFloat(OrderSum);
	        })
            $("#totalPrice").val(totalPrice.toFixed(2));
        }
    });	
}