
Ext.require([
    'Ext.grid.*',
    'Ext.data.*',
    'Ext.util.*',
    'Ext.state.*'
]);

var gridPanel;

//按范围修改单元格颜色
function rangesColor(val,metadata,record,rowIndex,colIndex,store){
	var obj=record.data;
	var ranges=obj.ranges;
	if (ranges==''){return val};
	var tRanges=ranges.split('-');

	if (parseFloat(val) < parseFloat(tRanges[0]) && (tRanges[0]!=''))
	{
		return '<span style="color:green;">'+ val + '</span>';
	};
	if (parseFloat(val) > parseFloat(tRanges[1]) && (tRanges[1]!='')){
	 	return '<span style="color:red;">'+ val + '</span>';
	};
	return val;
};

function showImage(val,metadata,record,rowIndex,colIndex,store){
	metadata.style = 'cursor:pointer;'
	return '<input id="show" type=image src="../images/webemr/laboldresult.gif" title="曲线图" onclick="showdesc(\'' +rowIndex+ '\')"/>'
}


function showdesc(rowIndex) {
	var rows = gridPanel.getStore().getAt(rowIndex);
	var colDesc,fn,res,colDescData,maxfield;
	var tcname=rows.get('tcname');
	var ranges=rows.get('ranges');
	var tranges=ranges.split('-');
	var data =[];
	colDescData=gColData.split(',')
   	for(var i = 2; i < gCols; i++){ 
		//var j=i+1;
		//colDesc=colDescData[i-1];
		var j=gCols-i+2;
		colDesc=colDescData[gCols-i];
		fn='date' + j ; 
		res=rows.get(fn);
		var tres=parseFloat(res);
		var lRange=parseFloat(tranges[0]);
		var hRange=parseFloat(tranges[1]);
		maxfield=hRange;
		if (res!=''){
			if (res>maxfield){maxfield=res};
			var tInt=parseFloat(maxfield);
			maxfield=parseFloat(maxfield);
			if (tInt<1 && tInt>0) {maxfield=maxfield+0.1};
			if (tInt<10 && tInt>1) {maxfield=maxfield+1};
			if (tInt<100 && tInt>10) {maxfield=maxfield+10};
			if (tInt<1000 && tInt>100) {maxfield=maxfield+50};
			if (tInt<10000 && tInt>1000) {maxfield=maxfield+100};
		}
		if (res!=''){	
			data.push({
				tcname:colDesc,
				visits:tres,
				views:maxfield,
				lRange:lRange,
				hRange:hRange
			});
		};
	};
	var storeGraph=Ext.create('Ext.data.JsonStore', {
		fields:['tcname','visits','views','lRange','hRange'],
		data:data
	});
	///显示图形窗口
	var wGraph=new Ext.Window({
		title: '【'+tcname+'】曲线图 参考范围【'+ranges+'】',
		width:900,
		height:600,
		layout:'fit',
		closeAction:'hide',
	        items:{
	            xtype: 'chart',
	            animate: false,
	            store: storeGraph,
	            //insetPadding: 30,
	            style: 'background:#fff',
 		           shadow: true,
    	        legend: {
                position: 'right'
      	      },	            
	            axes: [{
	                type: 'Numeric',
	                minimum: 0,
	                position: 'left',
	                fields: ['views'],
	                title: '曲线图',
	                grid: true,
	                label: {
	                    renderer: Ext.util.Format.numberRenderer('0,0'),
	                    font: '10px Arial'
	                }
	            }, {
	                type: 'Category',
	                position: 'bottom',
	                fields: ['tcname'],
	                title: '【'+tcname+'】',
	                label: {
	                    font: '10px Arial'
	                }
	            }],
	            series: [{
	                type: 'line',
	                axis: 'left',
	                xField: 'tcname',
	                yField: 'visits',
	                title: '结果',
	                listeners: {
	                  itemmouseup: function(item) {
	                      Ext.example.msg('Item Selected', item.value[1] + ' visits on ' + Ext.Date.monthNames[item.value[0]]);
	                  }  
	                },
	                tips: {
	                    trackMouse: true,
	                    width: 120,
	                    height: 40,
	                    renderer: function(storeItem, item) {
	                        this.setTitle(storeItem.get('tcname') + '<br />' + storeItem.get('visits'));
	                    }
	                },
	                style: {
	                    fill: '#38B8BF',
	                    stroke: '#38B8BF',
	                    'stroke-width': 3
	                },
	                markerConfig: {
	                    type: 'circle',
	                    size: 4,
	                    radius: 4,
	                    'stroke-width': 3,
	                    fill: '#38B8BF',
	                    stroke: '#38B8BF'
	                }
	            },{
	                type: 'line',
	                axis: 'left',
	                xField: 'tcname',
	                yField: 'lRange',
	                title:'参考范围低值',
	                style: {
	                    fill: '#00FF00',
	                    stroke: '#00FF00',
	                    'stroke-width': 1
	                },
	                markerConfig: {
	                    type: 'circle',
	                    size: 1,
	                    radius: 1,
	                    'stroke-width': 0,
	                    fill: '#00FF00',
	                    stroke: '#00FF00'
	                }
	          	},{
	                type: 'line',
	                axis: 'left',
	                xField: 'tcname',
	                yField: 'hRange',
	                title:'参考范围高值',
	                style: {
	                    fill: '#FF0000',
	                    stroke: '#FF0000',
	                    'stroke-width': 1
	                },
	                markerConfig: {
	                    type: 'circle',
	                    size: 1,
	                    radius: 1,
	                    'stroke-width': 0,
	                    fill: '#FF0000',
	                    stroke: '#FF0000'
	                }
	          	}]
	        }
		}); 
		
		wGraph.show();
};


function getToDays(NextDay){          
	var curDate = new Date();
	var NextDate=curDate.getTime()-1000*60*60*24*NextDay;           
	curDate.setTime(NextDate);           
	
	var strYear = curDate.getFullYear();        
	var strDay = curDate.getDate();        
	var strMonth = curDate.getMonth()+1;     
	if(strMonth<10)        
	{        
       strMonth="0"+strMonth;        
	}        
	datastr = strYear+"-"+strMonth+"-"+strDay;      
	return datastr;      
}      


Ext.onReady(function() {
    
		var tmpjson=Ext.JSON.decode(gGridData);    
    
    // create the data store
    var storedata = Ext.create('Ext.data.ArrayStore', {
        fields:tmpjson.fieldsNames,
        data:tmpjson.data
    });

    var columModle=tmpjson.columModle;

    // create the Grid
    gridPanel = Ext.create('Ext.grid.Panel', {
        store: storedata,
        //layout : 'border',
        //region : 'center',
        stateful: true,
        stateId: 'stateGrid',
        columns: columModle,
        height:'500',
        width: 'auto',
        //width: 800,
        title: gTSName,
        //renderTo: 'container',
        viewConfig: {
            stripeRows: true,
            forceFit:true
        }        
    });
		
		var headPanel=new Ext.Panel({
			//renderTo:'headpanel',
			labelAlign : 'right',
			labelWidth : 30,
			height:50,
			title:'历史结果开始日期',
			//widht:600,
			items:[{
				layout:'column',
				xtype: 'fieldset',
				items:[{
					xtype:'datefield',
					id:'startDate',
					value : StartDateValue,
					name : 'startDate',
					format : 'Y-m-d',
					fieldLabel : '开始日期',
					listeners:{  
						select:function(field,value,eOpts){
							var dt=Ext.util.Format.date(value,'Y-m-d'); 
							var lnk="dhclabviewoldresult.csp?&PatientBanner=1&OrderID="+OrderID+"&StartDate="+dt ;
							location.href=lnk;
	          }  
					}  
				},{
					xtype:'button',
					text:'一个月',
					handler:function(){
						  var dt=getToDays(30);
							var lnk="dhclabviewoldresult.csp?&PatientBanner=1&OrderID="+OrderID+"&StartDate="+dt ;
							location.href=lnk;
					}	
				},{
					xtype:'button',
					text:'三个月',
					handler:function(){
						  var dt=getToDays(90);
							var lnk="dhclabviewoldresult.csp?&PatientBanner=1&OrderID="+OrderID+"&StartDate="+dt ;
							location.href=lnk;
					}  
				},{
					xtype:'button',
					text:'六个月',
					handler:function(){
						  var dt=getToDays(180);
							var lnk="dhclabviewoldresult.csp?&PatientBanner=1&OrderID="+OrderID+"&StartDate="+dt ;
							location.href=lnk;
					}  
				},{
					xtype:'button',
					text:'所 有',
					handler:function(){
							var lnk="dhclabviewoldresult.csp?&PatientBanner=1&OrderID="+OrderID+"&StartDate=";
							location.href=lnk;
					}  
				},{
					xtype:'button',
					text:'返回',
					handler:function(){
						window.close();
					}  
				}]
			}]
		});


		var winfPanel = new Ext.Panel({
			renderTo:'headpanel',
			frame : true,
			autoHeight:true,
			width: 'auto',
			items:[
				headPanel,
				gridPanel
			]
		});

});

