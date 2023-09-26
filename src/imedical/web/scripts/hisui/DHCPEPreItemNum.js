//名称  DHCPEPreItemNum.js
//功能	预约项目限额
//组件	DHCPEPreItemNum	
//创建	2008.08.14
//创建人  xy

var onAfterRender = $.fn.datagrid.defaults.view.onAfterRender;
        $.extend($.fn.datagrid.defaults.view, {
            onAfterRender: function(target){
                onAfterRender.call(this, target);
          
               var objtbl = $(target).datagrid('getRows');
	           var rows=objtbl.length
	          
	           for (var i=0;i<rows;i++) {
		
				var ItemName=objtbl[i].TItemName
				var PreWNum=objtbl[i].TPreWNum
				var PreNum=objtbl[i].TPreNum
				var HadPreNum=objtbl[i].THadPreNum
				
				if(PreWNum==""){var PreWNum=0;}
	     		var PreWNum=parseInt(PreWNum)
	     		var HadPreNum=parseInt(HadPreNum) 
	     		var PreNum=parseInt(PreNum)
	            var index=i
	           	           
				if (HadPreNum>=PreWNum) {
				
		      	$("td .datagrid-view2 tr.datagrid-row[datagrid-row-index="+index+"]").css({"background-color":"red"}); 
					
				}
				
				if (HadPreNum>=PreNum) {
				
			    $("td .datagrid-view2 tr.datagrid-row[datagrid-row-index="+index+"]").css({"background-color":"#FF00FF"});	
			
				}

	           }

	           
            }
});




