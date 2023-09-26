//页面Event
function InitSpecimenWinEvent(obj){		
	obj.LoadEvent = function(args){

    }
    	
	$('#searchbox').searchbox({ 
		searcher:function(value,name){ 
			obj.gridSpecimen.load({
				ClassName:"DHCMA.Util.EPS.SpecimenSrv",
				QueryName:"QrySpecimen",
				aAlias:value
			});
		}
	});
}
