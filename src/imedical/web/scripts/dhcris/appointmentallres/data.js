

function showWeek(changeDate)
{
	//startDate.getDay()
	var num = changeDate.getDay();
	var Week = ['日','一','二','三','四','五','六'];  
    var str = '星期' + Week[num]; 
    return str;
}

//list1
var resSchduleListProxy1 = new Ext.data.HttpProxy(
	new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	})
);

resSchduleListProxy1.on('beforeload',resSchduleListBeforeload1);

function resSchduleListBeforeload1(objProxy,param)
{
	param.ClassName='web.DHCRisBookAllResource';
	param.QueryName='QuerySchduleDetail';
	param.Arg1=OeorditemID;
	param.Arg2=Ext.getCmp("bookDate1").value;
	param.Arg3 = locRowid;
	param.Arg4 = resourceCmb.getValue();
	param.ArgCnt=4;
}

var resSchduleStore1 = new Ext.data.Store({
	proxy : resSchduleListProxy1,
	reader : new Ext.data.JsonReader({
		root : 'record',
		totalPropery : 'total',
		idProperty : 'Group'
	},
	[
		{name:'resDesc',mapping:'ResourceDesc'},
		{name:'resRowid',mapping:'ResID'},
		{name:'date',mapping:'BookedDate'},
		{name:'time',mapping:'TimeDesc'},
		//{name:'time',mapping:''},
		{name:'docName',mapping:'docName'},
		{name:'maxNum',mapping:'MaxNumber'},
		{name:'remainNum',mapping:'ReUnLockBKNumber'},
		{name:'resSchduleRowid',mapping:'SchRowid'},
		{name:'nextBookTime',mapping:'nextBookTime'},
		{name:'timeFlag',mapping:'TimeFlag'}
		
	]
	)
});
/*
var btnShow=new Ext.grid.ButtonColumn({   // <reference path="ButtonColumn.js" /> 
           buttenText:'按钮', 
           Caption : "是否显示", 
           Name : 'IsView', 
           onClick:function(ButtonColumn,grid,record,field,value){
	           
	           
	           }, 
           width: 55 
        });    
   */     
var resListGrid1 = new Ext.grid.GridPanel({
	id : 'resListGrid1',
	store : resSchduleStore1,
	autoScroll:true,
	anchor: '97% 89%',
	//width:500,
	//height:300,
	layout:"fit",
	style:'border: 1px solid #8db2e3;',
	columns:[
		//btnShow,
		{
          text:"操作",
          width:50,
          align:"center",
          renderer:function(value,cellmeta){
            var returnStr = "<INPUT type='button' value='明细'>";
            return returnStr;
          }
     	 },
		{header:'资源',width:120,dataIndex:'resDesc',sortable:true},
		{header:'时间段',width:100,dataIndex:'time',sortable:true},
		
		{header:'剩余数',width:70,dataIndex:'remainNum',sortable:true},
		{header:'总数',width:70,dataIndex:'maxNum',sortable:true},
		{header:'预约时间',width:70,dataIndex:'nextBookTime',sortable:true},
		{header:'出诊医生',width:80,dataIndex:'docName',sortable:true},
		{header:'日期',width:80,dataIndex:'date',sortable:true},
		{header:'schRowid',width:50,dataIndex:'resSchduleRowid'},
		{header:'时间标志',width:50,dataIndex:'timeFlag'}
		
	],
	viewConfig: {
        //forceFit: true,

        //Return CSS class to apply to rows depending upon data values
        /*
        getRowClass: function(record, index) {
            var c = record.get('timeFlag');
            //
            if (c == "AM") {
                return 'view-am';
                //return 'hideRisBook';
            } else if (c == "PM") {
                return 'view-pm';
            }
            
        }
        */
    }

});

var docProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
}));


var docStore = new Ext.data.Store({
	proxy : docProxy,
	reader : new Ext.data.JsonReader({
		root:'record',
		totalProperty:'total',
		idProperty:'Group'
	},
	[
		{name:'docName',mapping:'DocDesc'}
		,{name:'docInit',mapping:'DocCode'}
		
	])
});


var docCmb = new Ext.form.ComboBox({
 	store:docStore,
 	displayField:'docName',
 	valueField:'docInit',
    fieldLabel:'医生',
    typeAhead : true,
    forceSelection : true,
    anchor:'100%',
    enableKeyEvents:true,
	triggerAction:'all',
	id:'docCmb',
	selectOnFocus : true,
	listeners : {
			
			'select':function(){
				//loadResSchduleStore();
				//alert(Ext.getCmp("docCmb").getRawValue());
				var docNameSel = Ext.getCmp("docCmb").getRawValue();
				var storeGet = resListGrid1.getStore();
				var num = storeGet.getCount();
				for (i=0;i<num;i++)
				{
					var docName = storeGet.getAt(i).get('docName');
					if (docNameSel!="" && docName!=docNameSel)
					{
						resListGrid1.getView().getRow(i).style.display='none';
					}
					else
					{
						resListGrid1.getView().getRow(i).style.display="";
					}
				}
				/*
				itemGrid.getView().getRow(girdcount).style.backgroundColor='#FFFF00';
				*/
			},
			'keypress':function(obj,e)
			{
		       if (e.getKey() == e.ENTER ) {    //&& this.getValue().length = 0
		       		var storeGet = resListGrid1.getStore();
							var num = storeGet.getCount();
							for (i=0;i<num;i++)
							{							
									resListGrid1.getView().getRow(i).style.display="";
							}
		       }  
		   } 
		}
 
 });



var list1 = new Ext.Panel({
	 width:500,
	 height:300,
	 layout:'form',
	 //labelWidth:60,
	 labelAlign:'right',
	 items:[
	 /*
		{
				xtype:'datefield',
				//width:200,
				id:'bookDate1',
				fieldLabel:'日期',
				anchor:'50%',
				format:'Y-m-d',
				//labelAlign:'right',
				value:new Date()
		}*/
		new Ext.Panel({
				border:false,
				layout:'column',
				height:25,
				items:[
					new Ext.Panel({
						width:250,
						layout:'form',
						border:false,
						//labelWidth:50,
						labelAlign:'right',
						items:[
							//new Ext.DatField({
							{
									xtype:'datefield',
									//width:200,
									id:'bookDate1',
									fieldLabel:'日期',
									anchor:'90%',
									//format:'Y-m-d',
									//labelAlign:'right',
									value:new Date(),
									listeners:{
						
										"select":function(field,value)
										{
											//alert("1");
											Ext.getCmp("week1").setValue(showWeek(Ext.getCmp("bookDate1").getValue()));
											resSchduleStore1.load();
										}
									}
						
							}
							//})
						]
					}),
					new Ext.Panel({
						width:100,
						layout:'fit',
						border:false,
						items:[
							{
								xtype:'displayfield',
								value:showWeek(Ext.getCmp("bookDate1").getValue()),
								name:'week1',
								id:'week1',
								style:'color:blue;font-size:18px'
							}
						]
					})
					/*,
					new Ext.Panel({
						width:210,
						layout:'form',
						labelWidth:50,
						border:false,
						items:[docCmb]
					})
					*/	
				]
		}),
		resListGrid1
	 ]
});


//list2
var resSchduleListProxy2 = new Ext.data.HttpProxy(
	new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	})
);

resSchduleListProxy2.on('beforeload',resSchduleListBeforeload2);

function resSchduleListBeforeload2(objProxy,param)
{
	param.ClassName='web.DHCRisBookAllResource';
	param.QueryName='QuerySchduleDetail';
	param.Arg1=OeorditemID;
	param.Arg2=Ext.getCmp("bookDate2").value;
	param.Arg3 = locRowid;
	param.Arg4 = resourceCmb.getValue();
	param.ArgCnt=4;
}

var resSchduleStore2 = new Ext.data.Store({
	proxy : resSchduleListProxy2,
	reader : new Ext.data.JsonReader({
		root : 'record',
		totalPropery : 'total',
		idProperty : 'Group'
	},
	[
		{name:'resDesc',mapping:'ResourceDesc'},
		{name:'resRowid',mapping:'ResID'},
		{name:'date',mapping:'BookedDate'},
		{name:'time',mapping:'TimeDesc'},
		//{name:'time',mapping:''},
		{name:'docName',mapping:'docName'},
		{name:'maxNum',mapping:'MaxNumber'},
		{name:'remainNum',mapping:'ReUnLockBKNumber'},
		{name:'resSchduleRowid',mapping:'SchRowid'},
		{name:'nextBookTime',mapping:'nextBookTime'},
		{name:'timeFlag',mapping:'TimeFlag'}  
		
	]
	)
});

var resListGrid2 = new Ext.grid.GridPanel({
	id : 'resListGrid2',
	store : resSchduleStore2,
	autoScroll:true,
	anchor: '97% 89%',
	//width:500,
	//height:300,
	layout:"fit",
	style:'border: 1px solid #8db2e3;',
	columns:[
		{
          text:"操作",
          width:50,
          align:"center",
          renderer:function(value,cellmeta){
            var returnStr = "<INPUT type='button' value='明细'>";
            return returnStr;
          }
     	 },
		{header:'资源',width:120,dataIndex:'resDesc',sortable:true},
		{header:'时间段',width:100,dataIndex:'time',sortable:true},
		
		{header:'剩余数',width:70,dataIndex:'remainNum',sortable:true},
		{header:'总数',width:70,dataIndex:'maxNum',sortable:true},
		{header:'预约时间',width:70,dataIndex:'nextBookTime',sortable:true},
		{header:'出诊医生',width:80,dataIndex:'docName',sortable:true},
		{header:'日期',width:80,dataIndex:'date',sortable:true},
		{header:'schRowid',width:50,dataIndex:'resSchduleRowid'},
		{header:'时间标志',width:50,dataIndex:'timeFlag'}
		
	],
	viewConfig: {
        //forceFit: true,

        //Return CSS class to apply to rows depending upon data values
        /*
        getRowClass: function(record, index) {
            var c = record.get('timeFlag');
            //
            if (c == "AM") {
                return 'view-am';
                //return 'hideRisBook';
            } else if (c == "PM") {
                return 'view-pm';
            }
            
        }*/
    }
});


var list2 = new Ext.Panel({
	 width:500,
	 height:300,
	 layout:'form',
	 //labelWidth:60,
	 labelAlign:'right',
	 items:[
	 /*
		{
				xtype:'datefield',
				//width:200,
				id:'bookDate2',
				fieldLabel:'日期',
				anchor:'50%',
				format:'Y-m-d',
				//labelAlign:'right',
				value:(new Date().add(Date.DAY,1))
		},
		*/
		new Ext.Panel({
				border:false,
				layout:'column',
				height:25,
				items:[
					new Ext.Panel({
						width:250,
						layout:'form',
						border:false,
						//labelWidth:100,
						labelAlign:'right',
						items:[
							{
									xtype:'datefield',
									//width:200,
									id:'bookDate2',
									fieldLabel:'日期',
									anchor:'90%',
									//format:'Y-m-d',
									//labelAlign:'right',
									value:(new Date().add(Date.DAY,1)),
									listeners:{
						
										"select":function(field,value)
										{
											Ext.getCmp("week2").setValue(showWeek(Ext.getCmp("bookDate2").getValue()));
											resSchduleStore2.load();
										}
									}
							}
						]
					}),
					new Ext.Panel({
						width:100,
						layout:'fit',
						border:false,
						items:[
							{
								xtype:'displayfield',
								value:showWeek(Ext.getCmp("bookDate2").getValue()),
								name:'week2',
								id:'week2',
								style:'color:blue;font-size:18px'
							}
						]
					})
				]
		}),
		resListGrid2
	 ]
});







var panelRes = new Ext.Panel({
	id:'mainPanel',
	baseCls:'x-plain',
	layout:'table',
	layoutConfig:{columns:2},
	defaults:{frame:false,width:500,height:300},
	items:[
		{
			//title:'item 1',
			items:[list1]
		},
		{
			//title:'item 2',
			items:[list2]
		}
		
	]

});



resListGrid1.on('rowclick', clickOrderList);
resListGrid2.on('rowclick', clickOrderList);

resListGrid1.on('cellClick', cellClick);
resListGrid2.on('cellClick', cellClick);

function cellClick(grid, rowIndex, columnIndex, e)
{
	//alert(cellIndex);
    if(columnIndex==0)
    {
               // alert(grid.getStore().getAt(rowIndex).data.time);
         var param="&ResSchduleId="+grid.getStore().getAt(rowIndex).data.resSchduleRowid; 
	
		   var link="websys.default.csp?WEBSYS.TCOMPONENT=DHCRisQueryResDetailResSch"+param;
		   //alert(link);
	       var mynewlink=open(link,"DHCRisLocStatics","scrollbars=yes,resizable=yes,top=6,left=6,width=900,height=680");
	          
	 }
 }


function clickOrderList(grid, rowIndex, columnIndex, e) 
{
	  Ext.getCmp("bookRes").setValue(grid.getStore().getAt(rowIndex).data.resDesc);
	  Ext.getCmp("bookDate").setValue(grid.getStore().getAt(rowIndex).data.date);
	  Ext.getCmp("bookTime").setValue(grid.getStore().getAt(rowIndex).data.time);
	  
	  Ext.getCmp("schduleRowidSel").setValue(grid.getStore().getAt(rowIndex).data.resSchduleRowid);
		//alert(grid.getStore().getAt(rowIndex).data.resDesc);
		if (grid==resListGrid1)
		{
			resListGrid2.getSelectionModel().clearSelections();

		}
		else if (grid==resListGrid2)
		{
			resListGrid1.getSelectionModel().clearSelections();
		}	
		
}