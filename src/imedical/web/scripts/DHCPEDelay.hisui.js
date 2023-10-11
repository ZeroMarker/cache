 
/*
 * FileName: DHCPEDelay.hisui.js
 * Author: sunxintao
 * Date: 2021-07-24
 * Description: 延期项目查询
 */
 
$(function(){
	
	//初始化 DelayGrid	
	InitDelayGrid();  
     
    //查询
	$("#BFind").click(function() {	
		BFind_click();		
        });
    
	 $("#RegNo").keydown(function(e) {
			
			if(e.keyCode==13){
				BFind_click();
			}
			
        });

	 $("#Name").keydown(function(e) {
			
			if(e.keyCode==13){
				BFind_click();
			}
			
        });

    //清屏
	$("#BClear").click(function() {	
		BClear_click();		
        });
    
    
    
})


//查询
function BFind_click(){
	
	var LocID=session['LOGON.CTLOCID'];
	var RegNo=$("#RegNo").val();
	if(RegNo!="") {
		var RegNo=tkMakeServerCall("web.DHCPE.DHCPECommon","RegNoMask",RegNo,LocID);
		$("#RegNo").val(RegNo)
		}
	
	$("#DelayGrid").datagrid('load',{
			ClassName:"web.DHCPE.OrderPostPoned",
			QueryName:"CheckDelay",
			DateBegin:$("#BeginDate").datebox('getValue'),
			DateEnd:$("#EndDate").datebox('getValue'),
			RegNo:$("#RegNo").val(),
			Name:$("#Name").val(),
			LocID:LocID
			});
}


//清屏
function BClear_click(){	
	$("#BeginDate,#EndDate").datebox('setValue');
	$("#RegNo,#Name").val("");	
	BFind_click();
}


function InitDelayGrid(){
	    var LocID=session['LOGON.CTLOCID'];
		$HUI.datagrid("#DelayGrid",{
		url:$URL,
		fit : true,
		border : false,
		striped : true,
		fitColumns : false,
		autoRowHeight : false,
		rownumbers:true,
		pagination : true,  
		rownumbers : true,  
		pageSize: 20,
		pageList : [20,100,200],
		singleSelect: false,
		selectOnCheck: true,
		queryParams:{
			ClassName:"web.DHCPE.OrderPostPoned",
			QueryName:"CheckDelay",
			LocID:LocID
		},
		columns:[[
			{field:'TRegNo',width:250,title:'登记号'},
			{field:'TName',width:250,title:'姓名'},
			{field:'DateDesc',width:200,title:'延期日期'},
			{field:'ArcDesc',width:680,title:'延期项目'},
			{field:'IfComplateAll',width:150,title:'全部做完再总检',align:'center'}
			/*{field:'IfComplateAll',width:150,title:'全部做完再总检',align:'center',
				formatter: function (value, rec, rowIndex) {
					if(value=="是"){
						return '<input type="checkbox" checked="checked" value="' + value + '" disabled/>';
					}else{
						return '<input type="checkbox" value="" disabled/>';
					}
				}
                        
			}*/	
			
		]]
			
	})	
}


