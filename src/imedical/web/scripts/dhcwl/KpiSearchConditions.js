(function(){
	Ext.ns("dhcwl.mkpi.KpiSearchConditions");
})();

dhcwl.mkpi.KpiSearchConditions=function(){
	var outThis=this;
	var searchCriteria="";
	var menuAct="";
	var mmSEDateCfgObj=null;

	
	comboObj = [
        ['mode','模块'],
        ['table','报表'],
        ['dataset','数据集'],
        ['kpi','指标']
    ];
	comboAttrib = [
		['code','编码'],
		['desc','描述']
	];	
	
	
	var formPanel = new Ext.FormPanel({
        labelWidth: 55, 
        frame:true,
        bodyStyle:'padding:5px 5px 0',
        //height:100,
        defaultType: 'textfield',

        items: [new Ext.form.ComboBox({
       			id:'ComboObjID',
       			fieldLabel: '对象',
		        store: comboObj,
		        typeAhead: true,
		        forceSelection: true,
		        triggerAction: 'all',
		        //emptyText:'Select a state...',
		        width: 150,
		        selectOnFocus:true   
		    }),new Ext.form.ComboBox({
       			id:'ComboAttribID',
       			fieldLabel: '属性',
		        store: comboAttrib,
		        typeAhead: true,
		        forceSelection: true,
		        triggerAction: 'all',
		        //emptyText:'Select a state...',
		        width: 150,
		        selectOnFocus:true   
		    }),new Ext.form.TextField({
		    	fieldLabel: '值',
				id:'searchValue',
				width: 150
				//autoWidth:true
				//emptyText:'Find a Class'
			})
        ],

        buttons: [{
            text: '搜索',
            handler : function(){}
        }]
    });	
	


	
	var SearchPanel=new Ext.Panel({
		frame:false,
		hidden :true,
	items: [{

		//collapsible: false,
		//id:"moduleCfgFormPanel",
		frame:false,
	    //margins: '5 0 0 0',
	    //cmargins: '5 5 0 0',
	    //height:300,
	    //minSize: 100,
	    //maxSize: 500,
	    items:formPanel			            
	}
	]}
	)
	

	
 	this.getSearchPanel=function(){
		return SearchPanel;
	}   


}
