//DHCDoc.CardOperation.js

   var count=0
$(window).load(function(){
	
});
$(document).ready(function() {
	          
        var width=screen.width
        $('#tt').tabs({
	       width:width,
            height:390,
            border : false,
            onSelect : function(title,index) {
                if (title != '��ʧ/����/����' ){
	                var tab=$('#tt').tabs('getSelected');
	                var obj=tab.find('iframe')[0].contentWindow.document.getElementById("RLName");
		            if (obj) obj.focus();
	            }else{
		            var tab=$('#tt').tabs('getSelected');
	                var obj=tab.find('iframe')[0].contentWindow.document.getElementById("CardNo");
		            if (obj) obj.focus();
		            
		        }
            }
        }); 
         Add()
         
    
});

function Add(){
	
	    
		var url="websys.default.csp?WEBSYS.TCOMPONENT=UDHCCardReportLoss&CardID="+CardID
	$('#tt').tabs('add',{ 
                    title:'��ʧ/����/����', 
                    content: '<iframe width="100%" height="100%" frameborder="0"  src="'+url+'" style="width:100%;height:100%;"></iframe>' 
                }); 
               
        
	var url="websys.default.csp?WEBSYS.TCOMPONENT=UDHCCardExchange&CardID="+CardID
    $('#tt').tabs('add',{ 
                    title:'����', 
                    content: '<iframe width="100%" height="100%" frameborder="0"  src="'+url+'" style="width:100%;height:100%;"></iframe>'
                });
     var url="websys.default.csp?WEBSYS.TCOMPONENT=UDHCCardCancel&CardID="+CardID
     $('#tt').tabs('add',{ 
                    title:'�˿�', 
                    content: '<iframe width="100%" height="100%" frameborder="0"  src="'+url+'" style="width:100%;height:100%;"></iframe>' 
                }); 
               
	
	$('#tt').tabs("select","��ʧ/����/����")
	}