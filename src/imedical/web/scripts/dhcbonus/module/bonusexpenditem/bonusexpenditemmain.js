var mainUrl = '../csp/dhc.bonus.module.bonusexpenditemexe.csp?action=list';
var tmpNode = "";
var addButton = new Ext.Toolbar.Button({
	text: '添加',
    tooltip:'添加',        
    iconCls:'add',
	handler:function(){
	
		var tmpRowid = "";
		var tmpcode = "";
		var tmpname = "";
		var tmpCalc = "";
		var tmpmonth="";
		var tmprate="";
		var tmpLeaf="";
		var tmpLevel=0;
		var tmpType="";
		
		if (tmpNode!="") {
			tmpRowid =   tmpNode.attributes["Rowid"];
			tmpcode = tmpNode.attributes["code"];
			tmpname =  tmpNode.attributes["name"];
			tmpCalc= tmpNode.attributes["IsCalcName"];
			tmpmonth = tmpNode.attributes["month"];
			tmprate = tmpNode.attributes["rate"];
			tmpLeaf = tmpNode.attributes["leaf"];
			tmpsuperid=tmpNode.attributes["SuperCode"];
			tmpLevel=tmpNode.attributes["ItemLevel"];
			tmpLevel=parseInt(tmpLevel);
			tmpType=tmpNode.attributes["expendtype"];
		}
		if(tmpLevel=="")
		{
			
		     tmpLevel=1;
		 
		}
		else
		{
			tmpLevel=tmpLevel+1;
        }
		if(tmpLeaf){
			Ext.Msg.show({title:'错误',msg:'末级不能添加子节点!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
		}else{
			
			var CodeField = new Ext.form.TextField({
				fieldLabel: '项目编码',
				width:180,
				anchor: '95%',
				selectOnFocus:'true'
			});
			
			var NameField = new Ext.form.TextField({
				fieldLabel: '项目名称',
				width:180,
				anchor: '95%',
				selectOnFocus:'true'
			});
		
		
			var CalcField = new Ext.form.Checkbox({												
				fieldLabel: '是否核算',
				value:true
			});
			
								
			
			//1会计科目
			//2医疗指标
			var MonthField = new Ext.form.ComboBox({												
				fieldLabel: '分摊月份',
				width:180,
				anchor: '95%',
				store : new Ext.data.ArrayStore({
					fields : ['rowid', 'name'],
					data : [['1', '一月'], ['2', '二月'], ['3', '三月'], ['4', '四月'], ['5', '五月'], ['6', '六月'], ['7', '七月'], ['8', '八月'], ['9', '九月'], ['10', '十月'], ['11', '十一月'], ['12', '十二月']]
				}),
				displayField : 'name',
				valueField : 'rowid',
				typeAhead : true,
				mode : 'local',
				value : '1',
				forceSelection : true,
				triggerAction : 'all',
				emptyText : '选择...',
				selectOnFocus:'true'
			});
		        var ExpendTypeFeild = new Ext.form.ComboBox({												
				fieldLabel: '支出类别',
				width:180,
				anchor: '95%',
				store : new Ext.data.ArrayStore({
					fields : ['rowid', 'name'],
					data : [['1', '人员工资'], ['2', '卫生材料'], ['3', '办公用品'], ['4', '折旧费'], ['5', '维修费用'], ['6', '公摊费用'], ['9', '其他成本']]
				}),
				displayField : 'name',
				valueField : 'rowid',
				typeAhead : true,
				mode : 'local',
				value : tmpType,
				forceSelection : true,
				triggerAction : 'all',
				emptyText : '选择...',
				selectOnFocus:'true'
			});
		    var RateField = new Ext.form.TextField({
				fieldLabel: '计提系数',
				width:180,
			
				anchor: '95%',
				selectOnFocus:'true'
			});
		
		    var LastField = new Ext.form.Checkbox({												
				fieldLabel: '是否末级',
				value:'true'
			});
			////////////////////////////////////////////////////////
		

			var colItems =	[
					{
						layout: 'column',
						border: false,
						defaults: {
							
							border: false
						},            
						items: [
							{
								xtype: 'fieldset',
								autoHeight: true,
								items: [
									CodeField ,				
									NameField,				
									CalcField,				
									MonthField,	
									ExpendTypeFeild	,		
									RateField,									
									CalcField,
									LastField	
								]
							}]
					}
				]			
			
			var formPanel = new Ext.form.FormPanel({
				//baseCls: 'x-plain',
				labelWidth: 80,
				//layout: 'form',
				frame: true,
				items: colItems
			});
	
			addButton = new Ext.Toolbar.Button({
				text:'添加'
			});

			addHandler = function(){
			
				var Code				= CodeField.getValue();
				var Name				= NameField.getValue();
				var Calc				= CalcField.getValue();	
				var Month				= MonthField.getValue();
				var Rate				= RateField.getValue();
				var Last		        = LastField.getValue();
				var ExpendType          =ExpendTypeFeild.getValue();

			
				if(Last){
					Last = 1;
				}else{
					Last = 0;
				}
				if(Calc){
					Calc = 1;
				}else{
					Calc = 0;
				}
				
				
           
				var data = Code+"|"+Name+"|"+Calc+"|"+Month+"|"+Rate+"|"+tmpRowid+"|"+Last+"|"+tmpLevel+"|"+ExpendType;
							
				if(formPanel.form.isValid()){
					Ext.Ajax.request({
						url: '../csp/dhc.bonus.module.bonusexpenditemexe.csp?action=add&data='+encodeURIComponent(data),
						waitMsg:'保存中...',
						failure: function(result, request){
							Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
						},
						success: function(result, request){
							var jsonData = Ext.util.JSON.decode( result.responseText );
							if (jsonData.success=='true'){
								Ext.Msg.show({title:'注意',msg:'添加成功!',icon:Ext.MessageBox.INFO,buttons:Ext.Msg.OK});
								
								if(tmpNode==""){
								mainGrid.root.reload();
								
								}
								else{
							   var tmp= mainGrid.getSelectionModel().getSelectedNode();
							    mainGrid.loader.load(tmp);
								tmp.expand(false);
							
								//mainGrid.loader.load(tmpNode);
								//tmpNode.expand(false);
								}
								
								tmpNode = "";
								//mainGrid.root.reload();
							}else{
								var tmpMsg = jsonData.info;
								Ext.Msg.show({title:'错误',msg:tmpMsg,buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
							}
						},
						scope: this
					});
				}else{
					Ext.Msg.show({title:'错误',msg:'请修正页面上的错误!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
				}
			}
			
			addButton.addListener('click',addHandler,false);
	
			cancelButton = new Ext.Toolbar.Button({
				text:'取消'
			});
			
			cancelHandler = function(){
				addwin.close();
			}
			
			cancelButton.addListener('click',cancelHandler,false);
	
			addwin = new Ext.Window({
				title: '添加核算项',
				width: 300,
				height: 300,
				//autoHeight: true,
				atLoad: true,
				layout: 'fit',
				plain:true,
				modal:true,
				bodyStyle:'padding:5px;',
				buttonAlign:'center',
				items: formPanel,
				buttons: [
					addButton,
					cancelButton
				]
			});
		
			addwin.show();
			
		}
	
	}
});

var editButton = new Ext.Toolbar.Button({
	text: '修改',
    tooltip:'修改',        
    iconCls: 'option',
	handler:function(){

		if(tmpNode==""){
			Ext.Msg.show({title:'错误',msg:'没有选择节点!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
		}else{
			tmpRowid =   tmpNode.attributes["Rowid"];
			tmpcode = tmpNode.attributes["code"];
			tmpname =  tmpNode.attributes["name"];
			tmpCalc= tmpNode.attributes["IsCalcName"];
			tmpmonth = tmpNode.attributes["month"];
			tmprate = tmpNode.attributes["rate"];
			tmpLeaf = tmpNode.attributes["leaf"];
			tmpType=tmpNode.attributes["expendtype"];
							
			if(tmpCalc=="是"){
				tmpCalc = true
			}else{
				tmpCalc = false
			}				
				
			
			var CodeField = new Ext.form.TextField({
				fieldLabel: '项目编码',
				width:180,
			    value:tmpcode,
				anchor: '95%',
				selectOnFocus:'true'
			});
			
			var NameField = new Ext.form.TextField({
				fieldLabel: '项目名称',
				width:180,
			    value:tmpname,
				anchor: '95%',
				selectOnFocus:'true'
			});
		
		
			var CalcField = new Ext.form.Checkbox({												
				fieldLabel: '是否核算',
				checked:tmpCalc
			});
			
								
			
			//1会计科目
			//2医疗指标
			var MonthField = new Ext.form.ComboBox({												
				fieldLabel: '分摊月份',
				width:180,
				anchor: '95%',
				store : new Ext.data.ArrayStore({
					fields : ['rowid', 'name'],
					data : [['1', '一月'], ['2', '二月'], ['3', '三月'], ['4', '四月'], ['5', '五月'], ['6', '六月'], ['7', '七月'], ['8', '八月'], ['9', '九月'], ['10', '十月'], ['11', '十一月'], ['12', '十二月']]
				}),
				displayField : 'name',
				valueField : 'rowid',
				typeAhead : true,
				mode : 'local',
			    value:tmpmonth,
				forceSelection : true,
				triggerAction : 'all',
				emptyText : '选择...',
				selectOnFocus:'true'
			});
			var ExpendTypeFeild = new Ext.form.ComboBox({												
				fieldLabel: '支出类别',
				width:180,
				anchor: '95%',
				store : new Ext.data.ArrayStore({
					fields : ['rowid', 'name'],
					data : [['1', '人员工资'], ['2', '卫生材料'], ['3', '办公用品'], ['4', '折旧费'], ['5', '维修费用'], ['6', '公摊费用'], ['9', '其他成本']]
				}),
				displayField : 'name',
				valueField : 'rowid',
				typeAhead : true,
				mode : 'local',
				value : tmpType,
				forceSelection : true,
				triggerAction : 'all',
				emptyText : '选择...',
				selectOnFocus:'true'
			});
		    var RateField = new Ext.form.TextField({
				fieldLabel: '技提系统',
				width:180,
				value:tmprate,
				anchor: '95%',
				selectOnFocus:'true'
			});
		
		    var LastField = new Ext.form.Checkbox({												
				fieldLabel: '是否末级',
				checked:tmpLeaf
			});
						////////////////////////////////////////////////////////
			
			
			var colItems =	[
					{
						layout: 'column',
						border: false,
						defaults: {
	
							border: false
						},            
						items: [
							{
								xtype: 'fieldset',
								autoHeight: true,
								items: [
									CodeField ,				
									NameField,				
									MonthField,	
									ExpendTypeFeild,			
									RateField,	
									CalcField,
									LastField
								]
							}]
					}
				]			
			
			var formPanel = new Ext.form.FormPanel({
				//baseCls: 'x-plain',
				labelWidth: 70,
				//layout: 'form',
				frame: true,
				items: colItems
			});
	
			editButton = new Ext.Toolbar.Button({
				text:'修改'
			});

			addHandler = function(){
			   
				var Code				= CodeField.getValue();
				var Name				= NameField.getValue();
				var Calc				= CalcField.getValue();	
				var Month				= MonthField.getValue();
				var Rate				= RateField.getValue();
				var Last		        = LastField.getValue();
				var ExpendType          = ExpendTypeFeild.getValue();
				if(Last){
					Last = 1;
				}else{
					Last = 0;
				}
				if(Calc){
					Calc= 1;
				}else{
					Calc = 0;
				}
	
	
				var data =Code+"|"+Name+"|"+Calc+"|"+Month+"|"+Rate+"|"+Last+"|"+ExpendType;
				if(formPanel.form.isValid()){
					Ext.Ajax.request({
						url: '../csp/dhc.bonus.module.bonusexpenditemexe.csp?action=edit&rowid='+tmpRowid+'&data='+encodeURIComponent(data),
						waitMsg:'保存中...',
						failure: function(result, request){
							Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
						},
						success: function(result, request){
							var jsonData = Ext.util.JSON.decode( result.responseText );
							if (jsonData.success=='true'){
								Ext.Msg.show({title:'注意',msg:'修改成功!',icon:Ext.MessageBox.INFO,buttons:Ext.Msg.OK});
								if(Last==1){
									
									var tmpPar=tmpNode.parentNode;
								
									mainGrid.loader.load(tmpPar);
									tmpPar.expand(false);
								}
								else{	
								mainGrid.root.reload();
								}
								tmpNode = "";
								editwin.close();
							}else{
								var tmpMsg = jsonData.info;
								Ext.Msg.show({title:'错误',msg:tmpMsg,buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
							}
						},
						scope: this
					});
				}else{
					Ext.Msg.show({title:'错误',msg:'请修正页面上的错误!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
				}
			}
			
			editButton.addListener('click',addHandler,false);
	
			cancelButton = new Ext.Toolbar.Button({
				text:'取消'
			});
			
			cancelHandler = function(){
				editwin.close();
			}
			
			cancelButton.addListener('click',cancelHandler,false);
	
			editwin = new Ext.Window({
				title: '修改核算项',
				width: 300,
				height: 300,
				//autoHeight: true,
				layout: 'fit',
				plain:true,
				modal:true,
				bodyStyle:'padding:5px;',
				buttonAlign:'center',
				items: formPanel,
				buttons: [
					editButton,
					cancelButton
				]
			});
		
			editwin.show();

		}
	}
});

var delButton = new Ext.Toolbar.Button({
	text: '删除',
    tooltip:'删除',        
    iconCls:'remove',
	handler:function(){
		var tmpRowid = "";
		var tmpLeaf = "";
		if (tmpNode!="") {
			tmpRowid =   tmpNode.attributes["Rowid"];
			tmpcode = tmpNode.attributes["code"];
			tmpname =  tmpNode.attributes["name"];
			tmpCalc= tmpNode.attributes["IsCalcName"];
			tmpmonth = tmpNode.attributes["month"];
			tmprate = tmpNode.attributes["rate"];
			tmpLeaf = tmpNode.attributes["leaf"];	
			
			function handler(id){
				if(id=="yes"){
					Ext.Ajax.request({
						url:'../csp/dhc.bonus.module.bonusexpenditemexe.csp?action=del&rowid='+tmpRowid+'&code='+tmpcode,
						waitMsg:'删除中...',
						failure: function(result, request){
							Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
						},
						success: function(result, request){
							var jsonData = Ext.util.JSON.decode( result.responseText );
							if (jsonData.success=='true'){
								Ext.Msg.show({title:'注意',msg:'删除成功!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
								tmpNode.remove();
								tmpNode.expand(false);
							}else{
								Ext.Msg.show({title:'错误',msg:'删除失败!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
							}
						},
						scope: this
					});
				}else{
					return;
				}
			}
			
			if(tmpLeaf){
				Ext.MessageBox.confirm('提示','确实要删除吗?',handler);
			}else{
				Ext.MessageBox.confirm('提示','含有子节点,确实要删除吗?',handler);
			}
	
		}else{
			Ext.Msg.show({title:'错误',msg:'请选择数据!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
		}
	}
});

var checkButton = new Ext.Toolbar.Button({
	text: '审核',
    tooltip:'审核',        
    iconCls:'remove',
	handler:function(){
		var tmpRowid = "";
		var tmpLeaf = "";
		var userid=session['LOGON.USERNAME'];
		if (tmpNode!="") {
			tmpRowid =   tmpNode.attributes["Rowid"];
			tmpcode = tmpNode.attributes["code"];
			tmpLeaf = tmpNode.attributes["leaf"];	
			
		
			function handler(id){
				if(id=="yes"){
					Ext.Ajax.request({
						url:'../csp/dhc.bonus.module.bonusexpenditemexe.csp?action=check&rowid='+tmpRowid+'&code='+tmpcode+'&user='+userid,
						waitMsg:'删除中...',
						failure: function(result, request){
							Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
						},
						success: function(result, request){
							var jsonData = Ext.util.JSON.decode( result.responseText );
							if (jsonData.success=='true'){
								Ext.Msg.show({title:'注意',msg:'审核成功!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
								mainGrid.root.reload();
							}else{
								Ext.Msg.show({title:'错误',msg:'审核失败!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
							}
						},
						scope: this
					});
				}else{
					return;
				}
			}
			
			if(tmpLeaf){
				Ext.MessageBox.confirm('提示','确实要审核吗?',handler);
			}else{
				Ext.MessageBox.confirm('提示','含有子节点,确实要审核吗?',handler);
			}
	
		}else{
			Ext.Msg.show({title:'错误',msg:'请选择数据!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
		}
	}
});
var mainGrid = new Ext.ux.tree.TreeGrid({
    title: '支出核算项配置',
	region: 'center',
    enableDD: true,

    columns:[{
        header: '支出项目',
        width: 160,
        dataIndex: 'name'
    },{
        header: '支出项目编码',
        width: 150,
        dataIndex: 'code'
    },{
        header: '分摊月份',
        width: 60,
        dataIndex: 'month'
    },{
        header: '是否核算',
        width: 60,
        dataIndex: 'IsCalcName'
    },
	//{
   //    header: '计算公式',
   //    width: 150,
   //    dataIndex: 'Formula'
   //},
   {
        header: '是否审核',
        width: 60,
        dataIndex: 'StateName'
    },
      
	{
        header: '计提系数',
        width: 100,
        dataIndex: 'rate'
    },
    
	{
        header: '上级单位编码',
        width: 100,
        dataIndex: 'SuperCode'
    },
	{
        header: '审核时间',
        width: 100,
        dataIndex: 'CheckDate'
    },{
        header: '审核人',
        width: 100,
        dataIndex: 'CheckMan'
    },{
        header: '更新时间',
        width: 100,
        dataIndex: 'updateData'
    },{
        header: '是否末级节点',
        width: 100,
        dataIndex: 'leaf'
    },{
        header: '节点层级',
        width: 100,
        dataIndex: 'ItemLevelName'
    },{
        header: '支出类别',
        width: 100,
        dataIndex: 'expendtypename'
    }],

    requestUrl: mainUrl,
	
	listeners: {
        'beforeload': function (node) {
       
         
            if (node.isRoot) {
	           
              this.loader.dataUrl = this.requestUrl + "&rnode=";
            }else { 
                var nodeText = node.attributes["Rowid"];
                var rqtUrl = this.requestUrl + "&rnode=" + nodeText;
                if (node.attributes.loader.dataUrl) {
                    this.loader.dataUrl = rqtUrl
                }
            }
          this.root.attributes.loader = null;
        },
		
		'click' : function( node,  e ) {
			tmpNode = node;
		}
    },
	
	tbar:[addButton,'-',editButton,'-',delButton,'-',checkButton]
});