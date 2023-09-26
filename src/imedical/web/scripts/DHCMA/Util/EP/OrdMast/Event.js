//页面Event
function InitOrdMastWinEvent(obj){	
	
	obj.LoadEvent = function(args){
    	
	}
	
	$('#searchbox').searchbox({ 
		searcher:function(value,name){ 
			obj.gridOrdMast.load({
				ClassName:"DHCMA.Util.EPS.OrdMastSrv",
				QueryName:"QryOrdMast",
				aAlias:value
			});
		}
	});

}
