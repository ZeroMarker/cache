function InitTestSetWinEvent(obj){		
	obj.LoadEvent = function(args){

    }
    $('#searchbox').searchbox({ 
		searcher:function(value,name){ 
			obj.gridTestSet.load({
				ClassName:"DHCMA.Util.EPS.TestSetSrv",
				QueryName:"QryTestSetByTC",
				aTCID:obj.RecRowID2,
				aAlias:value
			});
		}
	});
	
	$('#searchboxCode').searchbox({ 
		searcher:function(value,name){ 
			obj.gridTestCode.load({
				ClassName:"DHCMA.Util.EPS.TestSetSrv",
				QueryName:"QryTestCodeByTS",
				aTSID:obj.RecRowID1,
				aAlias:value
			});
		}
	});
}
