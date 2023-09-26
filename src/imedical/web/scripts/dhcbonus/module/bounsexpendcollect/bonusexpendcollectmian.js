//年月
	var yearmonth = new Ext.form.DateField({
		fieldLabel: '年月',
		name: 'yearmonth',
		width: 150,
		height:300,
		//value: (new Date()).getFullYear() + "" + "01",
		plugins: 'monthPickerPlugin',
		format: 'Y-m',
		editable: false
		// ,
	});
//	科室
var deptDs = new Ext.data.Store({
			autoLoad : true,
			proxy : "",
			reader : new Ext.data.JsonReader({
						totalProperty : 'results',
						root : 'rows'
					}, ['rowid', 'name'])
		});

deptDs.on('beforeload', function(ds, o) {
			ds.proxy = new Ext.data.HttpProxy({
						url : 'dhc.bonus.module.bonusexpendcollectexe.csp'
								+ '?action=getDept&str='
								+ encodeURIComponent(Ext.getCmp('deptCombo').getRawValue()),
						method : 'POST'
					})
		});

var deptCombo = new Ext.form.ComboBox({
			id : 'deptCombo',
			fieldLabel : '科室',
			width : 100,
			listWidth : 285,
			//allowBlank : false,
			store : deptDs,
			valueField : 'rowid',
			displayField : 'name',
			triggerAction : 'all',
			emptyText : '',
			name : 'deptCombo',
			minChars : 1,
			pageSize : 10,
			selectOnFocus : true,
			forceSelection : 'true',
			editable : true
		});
		
	var MethodField = new Ext.form.ComboBox({												
				fieldLabel: '方法接口',
				width:180,
				anchor: '95%',
				store : new Ext.data.ArrayStore({
					fields : ['rowid', 'name'],
					data : [['0', '全部成本数据'],['1', '物资材料请领'],['2', '人员工资经费'],['3', '固定资产折旧'],['4', '办公费用报销'],['90', 'Excel手动导入']]
				}),
				displayField : 'name',
				valueField : 'rowid',
				typeAhead : true,
				mode : 'local',
				value : '0',
				forceSelection : true,
				triggerAction : 'all',
				emptyText : '选择...',
				selectOnFocus:'true'
			});

		
var findButton = new Ext.Toolbar.Button({
			text : '查询',
			tooltip : '查询',
			iconCls:'option',
			handler : function() {
				var myyearmonth,deptcode,tariffTyp, MethodDr;
				if (yearmonth!=undefined){
				 myyearmonth = yearmonth.getRawValue();
				
				}
					
				if (deptCombo!=undefined){	
				 deptcode = deptCombo.getValue();
				}
			    if (MethodField!=undefined){	
				 MethodDr = MethodField.getValue();
				}
				itemGrid.load({
							params : {
								start : 0,
								limit : 25,
								yearmonth : myyearmonth,
								deptcode : deptcode,
							    MethodDr : MethodDr
							}
						});

			}
			
		})
var collectbutton = new Ext.Toolbar.Button(
		{
			text : '数据采集',
			tooltip : '数据采集',
			iconCls : 'option',
			handler : function() {  
				
				
				var myyearmonth = yearmonth.getRawValue();	
			function handler(id){
			if(id=="yes"){
				if (myyearmonth==""){
				Ext.Msg.show({title:'提示',msg:'请选择年月!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARING});
				return null;}
				var userid=session['LOGON.USERID'];
				var method=MethodField.getValue();
			
			if (method==""){
				Ext.Msg.show({title:'提示',msg:'请选择接口!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARING});
				return null;}
			
			
		        Ext.Ajax.request({
				url:'dhc.bonus.module.bonusexpendcollectexe.csp?action=collect&yearmonth='+myyearmonth+'&MethodDr='+method+'&userid='+userid,
		
				waitMsg:'采集中...',
				failure: function(result, request) {
					Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
				},
		
				success: function(result, request){
			   	var jsonData = Ext.util.JSON.decode( result.responseText );
				if (jsonData.success=='true'){
					Ext.Msg.show({title:'注意',msg:'采集成功！',icon:Ext.MessageBox.INFO,buttons:Ext.Msg.OK});
					itemGrid.load({
							params : {
								start : 0,
								limit : 25
							
							}
						});	
				}
				},
				scope: this
				});
			}}
				Ext.MessageBox.confirm('提示','确信要采集数据吗?',handler);
			}
});
var importButton = new Ext.Toolbar.Button({
					text : 'Excel导入',
					tooltip : 'Excel导入',
					iconCls : 'option',
					handler : function() {
						importExcel();
					}
				});
					var IsdriectField = new Ext.form.Checkbox({
			fieldLabel : '是否'
	});
var itemGrid = new dhc.herp.Grid({
        title: '原始支出数据查询',
        width: 400,
        edit:true,                   //是否可编辑
        readerModel:'remote',
        region: 'center',
        url: 'dhc.bonus.module.bonusexpendcollectexe.csp',	  
		    //atLoad : true, // 是否自动刷新
		    loadmask:true,
        fields: [{
		     id:'rowid',
		     header: 'rowid',
		     allowBlank: true,
		     width:100,
		     editable:false,
		     dataIndex: 'rowid',
		     hidden:true
		}, {
		     id:'yearperiod',
		     header: '所属年月',
		     allowBlank: true,
		     width:80,
		     editable:false,
		     dataIndex: 'yearperiod'
		}, {
		     id:'deptcode',
		     header: '科室编码',
		     allowBlank: true,
		     width:'auto',
		     editable:false,
		     dataIndex: 'deptcode',
		     hidden:true
		}, {
		     id:'deptname',
		     header: '科室名称',
		     allowBlank: true,
		     width:110,
		     editable:false,
		     dataIndex: 'deptname'
		   
		},  {
		     id:'MethordName',
		     header: '数据来源',
		     allowBlank: true,
		     width:100,
		     editable:false,
		     dataIndex: 'MethordName'
		},  {
		     id:'itemname',
		     header: '支出类别',
		     allowBlank: true,
		     width:130,
		     editable:false,
		     dataIndex: 'itemname'
		}, {
		     id:'itemvalue',
		     header: '支出金额',
		     allowBlank: true,
		     width:100,
		     align:'right',
		     editable:true,
		     dataIndex: 'itemvalue'
		}, {
		     id:'sstate',
		     header: '数据状态',
		     allowBlank: true,
		     width:100,
		     editable:false,
		     dataIndex: 'sstate'
		}, {
		     id:'collectdate',
		     header: '采集时间',
		     allowBlank: true,
		     width:110,
		     editable:false,
		     dataIndex: 'collectdate'
		},{
            id:'IaValue',
            header: '是否有效',
			width:80,
            dataIndex: 'IsValue',
            //sortable: true,          
            type : IsdriectField,
            renderer : function(v, p, record){
        	p.css += ' x-grid3-check-col-td'; 
        	return '<div class="x-grid3-check-col'+(v=='Y'?'-on':'')+' x-grid3-cc-'+this.id+'">&#160;</div>';}
        }],
        
        tbar:['年月:',yearmonth,'科室:',deptCombo,'采集接口:',MethodField,findButton,collectbutton,importButton]
        
});

	 	//itemGrid.hiddenButton(); 	//隐藏第n个按钮
		itemGrid.btnAddHide() ;	//隐藏增加按钮
		//itemGrid.btnSaveHide(); 	//隐藏保存按钮
		itemGrid.btnResetHide(); 	//隐藏重置按钮
		itemGrid.btnDeleteHide(); //隐藏删除按钮
		itemGrid.btnPrintHide() ;	//隐藏打印按钮