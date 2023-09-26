Ext.onReady(function(){
	var titleID;
	var detailID;
	var titlePanel;
	var DetailPanel;
	alert(getTitle)
    var ds = new Ext.data.Store({
		
        url: 'dhcpecrmfurecord.dpext.csp?action=list',
        reader: new Ext.data.JsonReader({
            totalProperty: "results",
            root: "rows"
        }, [{
            name: 'RowID',mapping:'RowID'
        }, {
            name: 'Code',mapping:'Code'
        }, {
            name: 'Desc',mapping:'Desc'
        }])
    });
	var detailds = new Ext.data.Store({
        url: 'dhcpecrmfurecord.dpext.csp?action=detailList&detailID=' + titleID,
        reader: new Ext.data.JsonReader({
            totalProperty: 'results',
            root: 'rows'
        }, [{
            name: 'RowID'
        }, {
            name: 'Code'
        }, {
            name: 'Desc'
        }, {
            name: 'Type'
        }, {
            name: 'Unit'
        }, {
            name: 'Explain'
        }, {
            name: 'Required'
        },{
			name:'Result'
		}])
    });
	ds.load();
	ds.on("load", dsLoad);
	
	function dsLoad(ds,record,options){
		var dsTotal = ds.getCount();
		var Arr=[];
			
		for (var i = 0; i < dsTotal; i++) {
			var OneArr=[];
		
			var titleRecord = ds.getAt(i);
			var titlelDesc = titleRecord.get("Desc");
			titleID = titleRecord.get('RowID');
			titlePanel = new Ext.Panel({
				title: titlelDesc,
				collapsed:false,
				collapsible:true,
				collapseFirst:true,
				layout:'form',
				id:titleID
			});
			OneArr[0]=titleID;
			OneArr[1]=titlePanel;
			Arr[i]=OneArr;
			detailds.proxy.conn.url ='dhcpecrmfurecord.dpext.csp?action=detailList&detailID=' + titleID,
			
			detailds.load();
			detailds.on("load",detaildsLoad);
			panel.add(titlePanel);
		};
		//SetDetail(Arr);
		panel.doLayout(true);
	}
	function SetDetail(Arr)
	{
		var options;
		var l=Arr.length;
		for (var i=0; i<l; i++) {
			titleID=Arr[i][0];
			//titlePanel=Arr[i][1];
			detailds.proxy.conn.url ='dhcpecrmfurecord.dpext.csp?action=detailList&detailID=' + titleID,
			detailds.load(options);
			detailds.on("load",detaildsLoad);
		};
	}
	function detaildsLoad(ds,record,options)
	{
		var dsTotal = ds.getCount();
		for (var i = 0; i < dsTotal; i++) {
			var detailRecord = ds.getAt(i);
			var detailDesc = detailRecord.get("Desc");
			detailID = detailRecord.get('RowID');
			var detailType=detailRecord.get('Type');
			var detailRequied=detailRecord.get('Requied');
			detailPanel = new Ext.Panel({
				title: detailDesc,
				collapsed:false,
				collapsible:true,
				collapseFirst:true
			});
			titlePanel.add(detailPanel);
		};
		titlePanel.doLayout(true);
		
	}
    var panel=new Ext.Panel({
		title:'随访调查',
		region: 'center',
		layout:'form'
	})
	var mainView = new Ext.Viewport({
    
        layout: 'border',
        collapsible: true,
        items: [panel]
    
    });
});



