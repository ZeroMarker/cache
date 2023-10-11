$(function(){
	Init();
});

function Init(){
	InitDataGrid();	
}
function InitDataGrid(){
	var columns=[[
        {field: 'OrderSum', title: unescape('总价'), width: 80, align: 'left'}
        ,{field: 'Price', title: '单价', width: 80, align: 'left'}
        ,{field: 'Priority', title: '医嘱类型', width: 90, align: 'left'}
        ,{field: 'Desc', title: '医嘱名称', width: 250, align: 'left',
        	styler: function(value,row,index){
				if (row.OEItemID == ServerObj.ordRowId){
					return 'background-color:red;color:#fff;';
				}
			}
		}
        ,{field: 'PackQty', title: '数量', width: 80, align: 'left'}
        ,{field: 'ReLoc', title: '接收科室', width: 150, align: 'left'}
        ,{field: 'Doctor', title: '医师', width: 100, align: 'left'}
        ,{field: 'OrdStatus', title: '医嘱状态', width: 100, align: 'left'}
        ,{field: 'OrdStartDate', title: '开始时间', width: 150, align: 'left'}
        ,{field: 'OrdBilled', title: '计费状态', width: 100, align: 'left'}
        ,{field: 'OrdXDate', title: '停止日期', width: 100, align: 'left',sortable: true}
        ,{field: 'OrdXTime', title: '停止时间', width: 100, align: 'left',sortable: true}
        ,{field: 'StopDoc', title: '停医嘱人', width: 100, align: 'left',sortable: true}
        ,{field: 'OEItemID', title: '医嘱编码', width: 100, align: 'left',sortable: true}
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
        loadMsg : '加载中..',  
        pagination : true,
        showPageList : false,
        pageSize:9999,
		pageList : [9999], 
        rownumbers : true,
        idField:"OEItemID",
        columns :columns,
        rowStyler: function(index,row){
            if (row.OrdStatus=="停止"){
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