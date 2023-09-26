
//组
var timeSpanGroup = new Ext.form.RadioGroup({
	//x:200,
	fieldLabel:'时间段',
	hideLabel:true,
	columns:2,
	//itemCls: 'x-check-group-alt',
	items:[]
	
});

timeSpanGroup.on('change',changeTimeSpan);

function changeTimeSpan(group, checked)
{
	var length = timeSpanGroup.getValue().inputValue;
	Ext.getCmp("startDate").setValue(new Date());
	Ext.getCmp("endDate").setValue(new Date().add(Date.DAY, length-1));
	
	initDateArray();
	addExamItem();
    //modalityStore.load();	
}


var timeSpanItems = [];

//动态加载时间段
function initTimeSpanGroup()
{
	//alert("1");
	timeSpanStore.load();
	for (var i = 0 ; i< timeSpanStore.getCount();i++)
	{
		var chk = {
			width:80,
		    items:[
			    {boxLabel:timeSpanStore.getAt(i).get('desc'),
				name:'timeSpanGroup',
				checked:(i==0?true:false),
				inputValue:timeSpanStore.getAt(i).get('days')}
		    ]
		};
			
		timeSpanItems.push(chk);
	}
	
	timeSpanGroup.items = timeSpanItems;
}


initTimeSpanGroup();


function initDateArray()
{
	//alert('2');
	dateStore.removeAll();
	var length = timeSpanGroup.getValue().inputValue;
	//alert(length);
	var dateStart = Ext.getCmp("startDate").getValue();
	var dateEnd = Ext.getCmp("endDate").getValue();
	
	var startDate=dateStart;
	
	//for ( var i = 0 ; i <length ; i++)
	while ( ( (dateEnd.getTime()-startDate.getTime())/3600/1000 ) >=0 )
	{
		var dateValue = new dateRecord({
			date:(startDate.getFullYear().toString())+
				 (((startDate.getMonth()+1)>9)?((startDate.getMonth()+1).toString()):('0'+(startDate.getMonth()+1).toString()))+
				 ((startDate.getDate()>9)?(startDate.getDate().toString()):('0'+startDate.getDate().toString())),
			     
			week:showWeek(startDate.getDay()),
			dateDesc:(startDate.getFullYear().toString())+"-"+
				 (((startDate.getMonth()+1)>9)?((startDate.getMonth()+1).toString()):('0'+(startDate.getMonth()+1).toString()))+
				 "-"+((startDate.getDate()>9)?(startDate.getDate().toString()):('0'+startDate.getDate().toString()))
			
		});
		//alert(dateValue.data['date']+" "+dateValue.data['week']);
	    dateStore.add(dateValue);
	    //startDate = new Date(Date.parse(startDate)+86400000); 
	    startDate = startDate.add(Date.DAY,1);
	}
	
}


/*	
var myMask = new Ext.LoadMask(
			Ext.get(serviceOrderGrid.getEl()),//serviceOrderGrid, 
			{
				msg:"Please wait...",
				store:serviceOrderStore
			});
//myMask.show();
*/

var timeSpanPanel = new Ext.form.FieldSet({
	//layout:'form', 
	title:'时间段',
	items:[
		timeSpanGroup
	]
});




var eastRegion = new Ext.FormPanel({
	title:"时间段",
	region:'west',
	//height:315,
	width:200,
	layout:"form",
	collapsible:false,
	//split:true,
	frame:true,
	autoScroll:true,
	items:[
		timeSpanPanel,
		{
			xtype:'panel',
			id:'panelStartDate',
			//layout:'form',
			layout: {
		        type: 'table',
		        columns: 2
		    },
			items:[
				//layout:'hbox',
				{ html: '开始日期：' },   //, rowspan: 3, height: 30
				/*{    
					xtype: 'label',    
					id: 'tbDummy1',    
					fieldLabel: '开始日期'    
				},*/
				{
					//xtype:''
					xtype:'datefield',
					width:100,
					id:'startDate',
					fieldLabel:'开始日期',
					hideLabel:true,
					//labelStyle: 'text-align:right;width:60;',
					//anchor:'95%',
					format:'Y-m-d',
					value:new Date()
					//emptyText:''
				}
			]
		},
		{
			xtype:'panel',
			id:'panelEndDate',
			//layout:'form',
			layout: {
		        type: 'table',
		        columns: 2
		    },
		    items:[
			    { html: '结束日期：' },
			    {
			    	xtype:'datefield',
					id:'endDate',
					fieldLabel:'结束日期',
					hideLabel:true,
					//anchor:'95%',
					width:100,
					format:'Y-m-d',
					value:new Date()
					//emptyText:''
				
			    
			    }
		    ]
			
		},
		{
			
			xtype:'panel',
			height:20
			//layout:'form',
		},
		{
			xtype:'panel',
			id:'panelFind',
			//layout:'form',
			layout: {
		        type: 'table',
		        columns: 2
		    },
			items:[
				//layout:'hbox',
				{ 
					xtype:'panel',
					width:60				
				},   //, rowspan: 3, height: 30
				
				{
					xtype:'button',
					id:'btnFind',
					text:'查询',
					//anchor:'95%',
					width:60,
					listeners:{	
						
				         click:function(){
				         	//alert("change");
				         	initDateArray();
							addExamItem();				         
				         }   
				             
					}
				}
			]
		}
		
	]
});