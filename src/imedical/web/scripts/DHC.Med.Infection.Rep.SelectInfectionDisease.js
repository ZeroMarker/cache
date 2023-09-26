function SelectInfectionDisease(objParent, evhandler,InfPosId)
{
	var obj = new Object();
	obj.txtPinyin = new Ext.form.TextField({fieldLabel:QueryCondition});
	obj.txtPinyin.on(
		"specialkey", 
		function(){
			var strAlias = this.txtPinyin.getValue();
			var objStore = this.gridDisease.getStore();
			objStore.removeAll();			
			if (strAlias.length < 2)
				return;
			var objArry = QueryInfectionDiseaseList("MethodQueryInfectionDiseaseList",strAlias,"InfectionSys"); //Modified By LiYang 2008-12-3 Use infection system's diagnose dictionary
			var objRec = null;
			var obj = null;
			for(var i = 0; i < objArry.length ; i ++)
			{
				obj = objArry[i];
				objRec = new Ext.data.Record(
					{
					RowID:obj.RowID,
					ICD:obj.ICD,
					DiseaseName:obj.DiseaseName,
					Pinyin:obj.PinyYin,
					Type:obj.DiseaseType,
					ResumeText:obj.ResumeText,
					DiseaseObj:obj
					}
				)
				objStore.add([objRec]);
			}
		}, 
		obj
	);
	/*
	obj.gridDisease = new Ext.grid.GridPanel({
		store: new Ext.data.SimpleStore({
			fields: [
				{name: 'RowID'},
				{name: 'ICD'},
				{name: 'DiseaseName'},
				{name: 'Pinyin'},
				{name: 'Type'},
				{name: 'ResumeText'},
				{name: 'DiseaseObj'}
			]
		}),
	        columns: [
			new Ext.grid.RowNumberer(),
			{id:'RowID', header: "ICD", width: 75, sortable: false, dataIndex: 'ICD'},
			{header: DiseaseName, width: 200, sortable: false, dataIndex: 'DiseaseName'},
			{header: DiseaseType, width: 75, sortable: false,  dataIndex: 'Type'},
			{header: ResumeText, width: 200, sortable: false,  dataIndex: 'ResumeText'}
	        ],
	        stripeRows: true,
	        height:190,
	        width:600
	});
	*/
	
	//*****************************************************
	//ColumnModel
	var cm = new Ext.grid.ColumnModel([
		new Ext.grid.RowNumberer(),
		{id:'RowID', header: "ICD", width: 75, sortable: false, dataIndex: 'ICD'},
		{header: DiseaseName, width: 200, sortable: false, dataIndex: 'DiseaseName'},
		{header: DiseaseType, width: 75, sortable: false,  dataIndex: 'Type'},
		{header: ResumeText, width: 200, sortable: false,  dataIndex: 'ResumeText'}
	]);
	cm.defaultSortable = false;
	//data store
	var objArry = QueryInfectionDiseaseListByPos("MethodQueryInfDiaByPos",InfPosId);
	var objRec = null,tmpobj=null;
	var ds= new Ext.data.Store;
	for(var i = 0; i < objArry.length ; i ++)
	{
		tmpobj = objArry[i];
		objRec = new Ext.data.Record(
			{
			RowID:tmpobj.RowID,
			ICD:tmpobj.ICD,
			DiseaseName:tmpobj.DiseaseName,
			Pinyin:tmpobj.PinyYin,
			Type:tmpobj.DiseaseType,
			ResumeText:tmpobj.ResumeText,
			DiseaseObj:tmpobj
			}
		)
		ds.add([objRec]);
	}

	//creat grid
	obj.gridDisease = new Ext.grid.GridPanel({
		ds: ds,
		cm: cm,
		width:600,
		height:250
	});
	//*****************************************************
	
	var objPane =({
		xtype:'fieldset',
		frame:true,
		//autoHeight:true,
		width:620,
		layout:"form",
		//renderTo:"BasePanel",
		items:[
			obj.txtPinyin,
			obj.gridDisease
		]
   	});
   	
	obj.Win = new Ext.Window({
		title:QueryDisease,
		//layout:'form',
		width:625,
		height:370,
		closeAction:'hide',
		plain: true,
		//autoHeight: true,
		//renderTo:"MainPanel",
	        modal:true,
	        items:[
			new Ext.FormPanel(objPane)
	        ],
	        buttons:[
	        	{
		        	text:strOK,
		        	handler:function()
		        	{
					var objData = GetGridSelectedData(obj.gridDisease);
					if(objData != null)
					{
						if(evhandler != null)
						{
							evhandler.call(objParent, objData);
							obj.Win.hide();
						}
					}else{
						Ext.Msg.alert(Notice, PleaseChooseItem);
					}
				}
	        	},
	        	{
	        	    text:Cancel,
	        	    handler:function(){obj.Win.hide();} 
	        	}
	        ]
	}); 
	return obj;
}








/*
function txtPinyin_OnChange()
{
	var strAlias = this.txtPinyin.getValue();
	var objArry = QueryInfectionDiseaseList("MethodQueryInfectionDiseaseList",strAlias);
	var objRec = null;
	var obj = null;
	var objStore = this.gridDisease.getStore();
	objStore.removeAll();
	for(var i = 0; i < objArry.length ; i ++)
	{
			obj = objArry[i];
			objRec = new Ext.data.Record(
					{
						RowID:obj.RowID,
				    ICD:obj.ICD,
				    DiseaseName:obj.DiseaseName,
				    Pinyin:obj.PinyYin,
				    Type:obj.DiseaseType,
				    ResumeText:obj.ResumeText,
				    DiseaseObj:obj
				  }
			)
			objStore.add([objRec]);
			
	}
}*/