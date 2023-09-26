(function(){
	Ext.ns("dhcwl.complexrpt.CreateRptData");
})();

 //生成报表对应的指标数据
dhcwl.complexrpt.CreateRptData=function(rptCode){
	this.rptCode=rptCode;
	var outThis=this;
	var hadChecked=0;	
	
    var form = new Ext.FormPanel({
      labelAlign : 'left',  
      frame : true,  
      bodyStyle : 'padding:5px',  
      //layout : 'form',
      layout: 'table',
      items: [  
        {
        	html: '开始时间：'
        },{  
            xtype: 'datefield',
            //fieldLabel: '开始时间',
            name : 'beginDate',
            //format:'Y-m-d',
            //editable:true,
            width:110
            //anchor : '70%'
        },{
        	html: '&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp结束时间：'
        },{  
            xtype : 'datefield',  
            //fieldLabel : '结束时间',  
            name : 'endDate',
            //format:'Y-m-d',
            //editable:true,
            width:110
            //anchor : '70%'
        }],  
      buttonAlign: 'center',
      buttons : [  
        {
          text: '<span style="line-Height:1">确定</span>',
          icon   : '../images/uiimages/ok.png',
          handler : function() {
			//var beginDate = Ext.get('beginDate').getValue();
			//var endDate = Ext.get('endDate').getValue();
			var beginDate = form.getForm().findField('beginDate').getRawValue();  
			var endDate = form.getForm().findField('endDate').getRawValue();
			if (beginDate=="" || endDate=="") {
				Ext.MessageBox.alert("提示","请选择时间段！");
				return;
			}
			var recs=grid.getSelectionModel().getSelections();
			//if(recs.length<=0) {
				//Ext.MessageBox.alert("提示","请先选择要操作的指标！");    					
				//return;
			//}
			var kpiCodes="";   	
			for (var i=0;i<=recs.length-1;i++){
					var kpiCode=recs[i].get("kpiCode");
				if (kpiCodes=="") {
					kpiCodes=kpiCode;
				}else{
					kpiCodes=kpiCodes+","+kpiCode;
				}
			}
			if (kpiCodes==""){
				Ext.MessageBox.alert("提示","请先选择要操作的指标！");
				return;
			}
			win.hide(this);
			var url='dhcwl/complexrpt/rptmkpidata.csp?action=creatRptKpiData';
			dhcwl.complexrpt.Util.ajaxExc(url,
				{
					KpiCodes:kpiCodes,
					StartDate:beginDate,
					EndDate:endDate
				},
				function(jsonData){
					if(jsonData.success==true && jsonData.tip=="ok"){
						Ext.Msg.alert("提示","数据生成成功!");
					}else{
						Ext.Msg.alert("提示",jsonData.tip);
					}
					Ext.getBody().unmask();
				},this,null,600000);
				Ext.getBody().mask("数据加载中，请稍等");
          }
        }, {  
		  text: '<span style="line-Height:1">取消</span>',
          icon   : '../images/uiimages/undo.png',
          handler : function() {
			form.getForm().findField('beginDate').setValue("");
			form.getForm().findField('endDate').setValue("");

			//清除CHECKBOX的头
			var hd_checker = grid.getEl().select('div.x-grid3-hd-checker');
			var hd = hd_checker.first();
			if(hd.hasClass('x-grid3-hd-checker-on')){
				hd.removeClass('x-grid3-hd-checker-on'); 
			}
			win.hide(this);		
			var kpiCodes="";
          }
        }
      ]
    });  
  
    
	var sm = new Ext.grid.CheckboxSelectionModel();	
	var store = new Ext.data.Store({
        proxy: new Ext.data.HttpProxy({url:'dhcwl/complexrpt/rptmkpidata.csp?action=getRptKpiInfo'+'&RptCode='+outThis.rptCode}),
        reader: new Ext.data.JsonReader({
            totalProperty: 'totalNum',
            root: 'root',
        	fields:[
        		{name: 'kpiId'},
            	{name: 'kpiCode'},
            	{name: 'rptName'}
       		]
    	})
    });
	store.load();
	var columns =new Ext.grid.ColumnModel([
		new Ext.grid.RowNumberer(),sm,
	    {header: "指标编码", dataIndex: 'kpiCode', width: 130, sortable: true,menuDisabled : true},
	    {header: "所属报表名称", dataIndex: 'rptName', width: 245, sortable: true,menuDisabled : true}
	]);

	var grid = new Ext.grid.GridPanel({
		title: '选择要操作的指标',
		height: 175,
		loadMask:true,
		store: store,
		cm: columns,
		sm: sm
	});  
    
    var win = new Ext.Window({  
      title : '报表数据生成',  
      //closable : false,  
      modal : true,  
      //modal为True表示为当window显示时对其后面的一切内容进行遮罩，  
      //false表示为限制对其它UI元素的语法（默认为 false）。  
      width : 440,  
      resizable : false,  
      plain : true,  
      //Plain为True表示为渲染window body的背景为透明的背景，这样看来window body与边框元素（framing elements）融为一体，  
      //false表示为加入浅色的背景，使得在视觉上body元素与外围边框清晰地分辨出来（默认为false）。  
      layout : 'form',  
      items : [grid,form]  
    });
    
    this.show=function(){  	
    	win.show();
    }
    
} 
