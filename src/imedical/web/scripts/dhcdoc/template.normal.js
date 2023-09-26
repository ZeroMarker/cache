//template.normal.js

   var count=0
$(window).load(function(){
	
});
$(document).ready(function() {
	          
        var width=screen.width
        $('#tt').tabs({
	       width:width,
            height:390,
            border : false,
            onSelect : function(title) {
	           
                if (title == 'π“ ß/∆Ù”√/≤πø®' ) {
	                
                    
                } else if (title == 'ªªø®') {
	                
	               
                } else if (title == 'ÕÀø®') {
	                
	                
                }
            }
        }); 
         Add()
         
    
});

function Add(){
	
	    
		var url="websys.default.csp?WEBSYS.TCOMPONENT=UDHCCardReportLoss&CardID="+CardID
	$('#tt').tabs('add',{ 
                    title:'π“ ß/∆Ù”√/≤πø®', 
                    content: '<iframe width="100%" height="100%" frameborder="0"  src="'+url+'" style="width:100%;height:100%;"></iframe>' 
                }); 
               
        
	var url="websys.default.csp?WEBSYS.TCOMPONENT=UDHCCardExchange&CardID="+CardID
    $('#tt').tabs('add',{ 
                    title:'ªªø®', 
                    content: '<iframe width="100%" height="100%" frameborder="0"  src="'+url+'" style="width:100%;height:100%;"></iframe>' 
                });
     var url="websys.default.csp?WEBSYS.TCOMPONENT=UDHCCardCancel&CardID="+CardID
     $('#tt').tabs('add',{ 
                    title:'ÕÀø®', 
                    content: '<iframe width="100%" height="100%" frameborder="0"  src="'+url+'" style="width:100%;height:100%;"></iframe>' 
                }); 
               
	
	$('#tt').tabs("select","π“ ß/∆Ù”√/≤πø®")
	}