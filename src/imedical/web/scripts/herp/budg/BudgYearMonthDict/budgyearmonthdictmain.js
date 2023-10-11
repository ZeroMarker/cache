var commonboxURL='herp.budg.budgcommoncomboxexe.csp';
var yeardictURL='herp.budg.budgyearmonthdictexe.csp';
var startDateField= new Ext.form.DateField({
	format:'Y-m-d',
	emptyText:'开始时间...',
	columnWidth:1
});
var endDateField= new Ext.form.DateField({
	format:'Y-m-d',
	emptyText:'结束时间...',
	renderer : function(v, p, r, i) {			
				if (v instanceof Date) {
					return new Date(v).format("Y-m-d");
				} else {
					return v;
				}
	},
	columnWidth:1
});

var smYearDs = new Ext.data.Store({
			proxy : "",
			reader : new Ext.data.JsonReader({
						totalProperty : "results",
						root : 'rows'
					}, ['year', 'year'])
		});

smYearDs.on('beforeload', function(ds, o) {

			ds.proxy = new Ext.data.HttpProxy({
						url : commonboxURL+'?action=year',
						method : 'POST'
					});
		});

var Year1Field = new Ext.form.ComboBox({
			fieldLabel : '年度',
			store : smYearDs,
			displayField : 'year',
			valueField : 'year',
			typeAhead : true,
			forceSelection : true,
			triggerAction : 'all',
			emptyText:'请选择年度...',
			//editable:false,
			width : 125,
			listWidth : 230,
			pageSize : 10,
			minChars : 1,
			anchor: '95%',
			selectOnFocus : true
		});
var date=new Date();
Year1Field.setValue(date.getFullYear()+1);


//选择年度自动生成按钮
var AutoButton = new Ext.Toolbar.Button({
	text: '自动生成',
	tooltip: '自动生成',
	iconCls: 'add',
	handler: function(){
		var year=Year1Field.getValue();
		if(year==""){
      		Ext.Msg.show({title:'提示',msg:'请选择年度!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
      		return;
		}else{
			AutoGenFun(year)
		}
	}
});

var itemGrid = new dhc.herp.Grid({
        title: '年月设置',
        width: 400,
        //edit:false,                   //是否可编辑
        readerModel:'remote',
        region: 'center',
        url: yeardictURL,	  
		atLoad : true, // 是否自动刷新
		loadmask:true,
		//tbar:['-',Year1Field],
        fields: [{
            header: 'ID',
            dataIndex: 'rowid',
			edit:false,
            hidden: true
        },{
            id:'yearmonth',
            header: '所属年月',
			allowBlank: false,
			width:200,
            dataIndex: 'yearmonth'
        },{
            id:'startdate',
            header: '开始时间',
			allowBlank: false,
			width:200,
            dataIndex: 'startdate',
           // type: startDateField,
            type: "dateField"
            /*
			renderer : function(v, p, r, i) {			
				if (v instanceof Date) {
					return new Date(v).format("Y-m-d");
				} else {
					return v;
				}
			}*/
        },{
            id:'enddate',
            header: '结束时间',
			allowBlank: false,
			width:200,
            dataIndex: 'enddate',
            type: "dateField",
            dateFormat: 'Y-m-d'/*,             
			renderer : function(v, p, r, i) {			
				if (v instanceof Date) {
					return new Date(v).format("Y-m-d");
				} else {
					return v;
				}
			},
			type: endDateField
			editor:new Ext.form.DateField({
						fieldLabel : '结束时间……',
						id : 'enddate',
						allowBlank: false,
						format : 'Y-m-d'//,
						//disabledDays : [0, 8],
						//disabledDaysText : 'Plants are not available on the weekends'
					})*/
        }] 
});

    itemGrid.hiddenButton(3);
	itemGrid.hiddenButton(4);
	itemGrid.addButton(Year1Field);
	itemGrid.addButton(AutoButton);


AutoGenFun = function(year) {
	
	Ext.Ajax.request({
				url: yeardictURL+'?action=autoadd&year='+year,
				failure: function(result, request) {
					Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
				},
				success: function(result, request) {
					var jsonData = Ext.util.JSON.decode( result.responseText );
					if (jsonData.success=='true') {
						Ext.Msg.show({title:'注意',msg:'处理成功!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
                        itemGrid.load();
					}
					else {
						var tmpMsg = jsonData.info+"处理失败!";
						Ext.Msg.show({title:'错误',msg:tmpMsg,buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
					}
				},
			  	scope: this
			});

}