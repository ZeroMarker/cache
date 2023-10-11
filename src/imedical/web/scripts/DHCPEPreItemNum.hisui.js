
//名称	DHCPEPreItemNum.hisui.js
//功能	预约限额数量查询	
//创建	2019.06.13
//创建人  xy
$(function(){
	
	InitPreItemNumDataGrid();
	
	//查询
	$("#BFind").click(function() {	
		BFind_click();		
        });
      
	
})



//查询
function BFind_click()
{
	$("#PreItemNumTab").datagrid('load',{
			ClassName:"web.DHCPE.PreManager",
			QueryName:"FindPreItemNum",
			Date:$("#Date").datebox('getValue'),
			LocID:session['LOGON.CTLOCID']		
			});
}


function InitPreItemNumDataGrid(){
	
$HUI.datagrid("#PreItemNumTab",{
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
		singleSelect: true,
		selectOnCheck: true,
		queryParams:{
			ClassName:"web.DHCPE.PreManager",
			QueryName:"FindPreItemNum",
			LocID:session['LOGON.CTLOCID']
		},
		columns:[[
		 	{field:'TPreNum',width:'300',title:'预约限额'},
			{field:'THadPreNum',width:'300',title:'已预约数量'},
			{field:'TPreWNum',width:'300',title:'预警数量'},
			{field:'TItemName',width:'400',title:'项目名称'},
			
			
		]],
		rowStyler:function(index,row){ 
			var PreWNum=row.TPreWNum;
			if(PreWNum==""){var PreWNum=0;}
			var HadPreNum=row.THadPreNum;
			if(HadPreNum==""){var HadPreNum=0;}
			var PreNum=row.TPreNum;
			if(PreNum==""){var PreNum=0;}
		 	var PreWNum=parseInt(PreWNum);
	    	 var HadPreNum=parseInt(HadPreNum);	     
	    	 var PreNum=parseInt(PreNum);
		
           if ((HadPreNum>=PreNum)&(HadPreNum!="0")){ 
                return 'background-color:#ffe3e3;';    
            } 
            if ((HadPreNum>=PreWNum)&(HadPreNum!="0")){  
                return 'background-color:#fff3dd;';    
            }
            
             
        }    
			
	})	
}