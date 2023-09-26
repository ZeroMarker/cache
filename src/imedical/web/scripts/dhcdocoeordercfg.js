/*********************以下为维护单独添加 页面部分**************************/
var windowAdd;

var formPanel;

var DescField=null;
var CodeField=null;

var SpecFlagField=null;
var SpecItem=null;

var ArcimFlagField=null;
var RefItem=null;
var SLASDateField=null;
var SLAEDateField=null;

var ArcosFlagField=null;
var RefARCOSItem=null;
var SLASArcosDateField=null;
var SLAEArcosDateField=null;
var sysdateFormat=tkMakeServerCall("websys.Conversions","DateFormat");
if (sysdateFormat==3) dateFormat="Y-m-d"
else if (sysdateFormat==4) dateFormat="d/m/Y"
else dateFormat="d/m/Y"
Ext.ux.DateField=Ext.extend(Ext.form.DateField,{
		//anchor : '100%',
	//	width : 80,
		format: dateFormat,
		//invalidClass:'',
		//invalidText:'',
		regexText:'请输入正确的日期格式!',
		initComponent:function(){
			var altFormats = 'j|d|md|ymd|Ymd'+'|Y-m|Y-n|y-m|y-n'+'|Y-m-d|Y-m-j|Y-n-d|Y-n-j|y-m-d|y-m-j|y-n-d|y-n-j';
			var regex = /^(t|(t[\+\-]\d*)|\d{1,2}|\d{4}|\d{6}|\d{8}|((\d{4}|\d{2})\-\d{1,2}\-\d{1,2}))$/;
			if(dateFormat == 'm/d/Y'){
				altFormats = 'j|d|md|mdy|mdY'+'|n/j|n/d|m/j|m/d'+'|n/j/y|n/j/Y|n/d/y|n/d/Y|m/j/y|m/j/Y|m/d/y|m/d/Y';
				regex = /^(t|(t[\+\-]\d*)|\d{1,2}|\d{4}|\d{6}|\d{8}|(\d{1,2}\/\d{1,2}\/(\d{4}|\d{2})))$/;
			}else if(dateFormat == 'd/m/Y'){
				altFormats = 'j|d|dm|dmy|dmY'+'|j/n|j/m|d/n|d/m'+'|j/n/y|j/n/Y|j/m/y|j/m/Y|d/n/y|d/n/Y|d/m/y|d/m/Y';
				regex = /^(t|(t[\+\-]\d*)|\d{1,2}|\d{4}|\d{6}|\d{8}|(\d{1,2}\/\d{1,2}\/(\d{4}|\d{2})))$/;
			}
			this.altFormats = altFormats;
			this.regex = regex;
			this.on('blur',function(e){
				var str=this.getRawValue();
				str=str.replace(/\s/g,"").toLowerCase();
				if(str=="t"){
					this.setValue(new Date());
				}
				else if(str.indexOf("t+")==0 || str.indexOf("t-")==0){
					var addDayNum=parseInt(str.substring(2));
					if(isNaN(addDayNum)){
						this.setValue('');
					}else{
						if(addDayNum=="") {addDayNum=0;}
						if(str.substring(1,2)=="-"){
							addDayNum=-addDayNum;
						}
						this.setValue(new Date().add(Date.DAY, parseInt(addDayNum)));
					}
				}else{
					this.setValue(this.getValue());
				}
			});
			this.on('specialkey',function(field,e){
				if (e.getKey() == Ext.EventObject.ENTER){
					this.fireEvent('blur');
				}
			});
			Ext.ux.DateField.superclass.initComponent.call(this);
		},
		/*
		 * 重写DateField的parseDate方法,对于6位数字格式化进行特殊处理
		 */
		parseDate : function(value) {
			if(!value || Ext.isDate(value)){
				return value;
			}
			var v = this.safeParse(value, this.format),
				af = this.altFormats,
				afa = this.altFormatsArray;
			if (!v && af) {
				afa = afa || af.split("|");
				for (var i = 0, len = afa.length; i < len && !v; i++) {
					if(afa[i] == 'ymd' && Ext.isString(value) && (Number(value) == value) && value.length == 6 && value.substring(2,4) > 12){
						//该if内为特殊处理部分, 形如201609(第3,4为>12)取该月最后一天,即20160930
						var firstDay = Date.parseDate(value + '01', 'Ymd');
						v = firstDay.getLastDateOfMonth();
					}else{
						v = this.safeParse(value, afa[i]);
					}
				}
			}
			return v;
		}
	});
	Ext.reg('uxdatefield',Ext.ux.DateField);
var addLocButton  = new Ext.Toolbar.Button({
	text: '增加',
	tooltip: '增加',
	iconCls: 'icon-add-custom',
	handler: function(){AddNode();}
});


var delLocButton  = new Ext.Toolbar.Button({
	text:'删除',
	tooltip:'删除选定的',
	iconCls:'icon-delete-custom',
	//disabled:'true',
	handler: function(){DeleteNode();}
});
var updateNodeButton  = new Ext.Toolbar.Button({
	text:'修改节点名',
	tooltip:'更新项目名',
	iconCls:'update',
	iconCls:'icon-update-custom',
	//disabled:'true',
	handler: UpdateNode
});
var updateLocButton  = new Ext.Toolbar.Button({
	text:'更新顺序',
	tooltip:'更新顺序',
	iconCls:'icon-update-custom',
	
	//disabled:'true',
	handler: function(){UpdateNodeSort();}
});

//左侧树样式
var treecfg = new Ext.tree.TreePanel({
	id:'treecfg',
	width:250,
	region: 'west',
	border:false,
	animate:true,
	enableDD:true,
	containerScroll:true,
	split: true,
	autoScroll:true,
	collapsible: true,
	rootVisible: true,
    title: RootNodeName+'选择',
    tbar: [addLocButton,'-',delLocButton,'-',updateNodeButton], //,'-',updateLocButton
    autoScroll:true,
    loader: new Ext.tree.TreeLoader({dataUrl:"dhcdocoeorderdata.csp?action=tree&Root="+RootNodeId}),
    root: new Ext.tree.AsyncTreeNode({
                  text: RootNodeName,
                  id:RootNodeId,
                value:'0',	
                expanded:true
    }),
    listeners:{
        "click":function(node,event){
			nodeclicked(node);
			if(!node.isLeaf()){
				//加载数据集
				grid.store.load({params:{PrentId:node.attributes.id}});
			}
			//grid.store.load();
			//Ext.Msg.alert('Navigation Tree Click', 'You clicked: "' + node.attributes.id + '"');
		}
    }
});

/********************************************************************/
/*********************以下为维护单独添加 业务处理部分*****************/
//2011-12-2
function UpdateNode(){
	var SelNodeObj = treecfg.getSelectionModel().getSelectedNode();
	if (!SelNodeObj) {
		alert("请选择一个项目")
		return;
	}
	var windowUpdate = new Ext.Window({
		title: '更新',
		iconCls:'icon-update-custom',
		width: 400, height:200,
		layout: 'form',
		buttonAlign:'center', closable:false,
		modal:true,plain:true,
		items: [{
			xtype:'field',id:'updateId',value:SelNodeObj.id	,hidden:true
			},{xtype:'field',fieldLabel:'项目名',id:'updateNodeName',value:SelNodeObj.text}
		],
		buttons: [{
			text: '保存', 
			iconCls:'icon-filesave-custom',
			id:"saveButton",
			handler: function() { 
				Ext.Ajax.request({
					url:'dhcdocoeorderdata.csp?action=updateNodeName',
					params: { nodeId: Ext.getCmp("updateId").getValue(), updateNodeName:Ext.getCmp("updateNodeName").getValue()},
					waitMsg:'更新中...',
					failure: function(result, request) {
						Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK});
					},
					success: function(result, request) {
						var jsonData = Ext.util.JSON.decode( result.responseText );
						if (jsonData.success=='true') {
							Ext.Msg.show({title:'注意',msg:'更新成功!',buttons: Ext.Msg.OK});
							SelNodeObj.setText(Ext.getCmp("updateNodeName").getValue());
							windowUpdate.close();
						}else{
							Ext.Msg.show({title:'错误',msg:"更新错误!",buttons: Ext.Msg.OK});
						}
					},
					scope: this
				}); 
			}
    	},{
			text: '取消',
			iconCls:'icon-undo-custom',
			handler: function(){windowUpdate.close();}
		}]
    });
    windowUpdate.show();
}
function AddNode(dataStore,grid,pagingTool){
	//Ext.QuickTips.init();
	var SelNodeObj = treecfg.getSelectionModel().getSelectedNode();
	//SelNodeObj.attributes.SpecItem	//有检验标本属性
	//SelNodeObj.findChildBy			//通过自定义的函数查找子节点
	if(!SelNodeObj||(SelNodeObj==null))
	{
		Ext.Msg.show({title:'注意',msg:'请选择分类!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
		return;
	}
	if(SelNodeObj.isLeaf())
	{
		Ext.Msg.show({title:'注意',msg:'您选择的节点,不能添加!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
		return;
	}
	if (SelNodeObj.id=="root") {
		//Ext.Msg.show({title:'注意',msg:'您选择的节点,不能添加!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
		//return;
	}
	
	var LeafChildNood=SelNodeObj.findChild("leaf",true);
	var RootNodeObj=SelNodeObj.getOwnerTree().root
	var FirstNode="";
	if (SelNodeObj.parentNode){
		FirstNode=SelNodeObj.parentNode.id.split("||")[0];
	}
	///最顶级的节点
	if (!SelNodeObj.parentNode) {
		DescField = new Ext.form.TextField({
			id:'Desc',
			fieldLabel: '名称',
			selectOnFocus:true,
			allowBlank: false,
			labelSeparator: '&nbsp',
			name:'Desc',
			emptyText:'名称...',
			anchor: '90%'
		});
		CodeField = new Ext.form.TextField({
			id:'Code',
			fieldLabel: '代码',
			selectOnFocus:true,
			allowBlank: false,
			labelSeparator: '&nbsp',
			name:'Desc',
			emptyText:'英文代码...',
			anchor: '90%'
		});
		
		if (LeafChildNood) {
			formPanel = new Ext.form.FormPanel({
				baseCls: 'x-plain',
				labelWidth: 90,
				items: [
					DescField,
					CodeField
				]
			});
		}else{
			formPanel = new Ext.form.FormPanel({
				baseCls: 'x-plain',
				labelWidth: 90,
				items: [
					DescField,
					CodeField
				]
			});
		}
	}else if ((FirstNode=="rootlab")||(SelNodeObj.id=="rootlab")) {
		DescField = new Ext.form.TextField({
			id:'Desc',
			fieldLabel: '名称',
			selectOnFocus:true,
			allowBlank: false,
			labelSeparator: '&nbsp',
			name:'Desc',
			emptyText:'名称...',
			anchor: '90%'
		});
		SpecFlagField = new Ext.form.Checkbox({
			id: 'SpecFlag',
			fieldLabel: '增加标本',
			labelSeparator: '&nbsp',
			allowBlank: true,
			checked:false,
			listeners:{
	        	"check":function(){
	        		if (this.checked==true) {
	        			ArcimFlagField.setValue(false);
						ArcosFlagField.setValue(false);

						var SpecItemData = new Ext.data.Store({
							proxy: "",
							reader: new Ext.data.JsonReader({totalProperty:"results",root:'rows'},['rowId','code','name'])
						});
						SpecItem = new Ext.form.ComboBox({
							id: 'RefItem',
							fieldLabel: '关联项目',
							labelSeparator: '&nbsp',
							anchor: '90%',
							listWidth : 260,
							allowBlank: false,
							store: SpecItemData,
							valueField: 'rowId',
							displayField: 'name',
							triggerAction: 'all',
							emptyText:'选择关联项目...',
							pageSize: 10,
							minChars: 1,
							selectOnFocus: true,
							forceSelection: true
						});
						SpecItemData.on('beforeload', function(ds, o){
							ds.proxy=new Ext.data.HttpProxy({url:encodeURI('dhcdocoeorderdata.csp?action=SpecItem&searchValue='+Ext.getCmp('RefItem').getRawValue()+"&RowId="+SelNodeObj.id),method:'GET'});
						});
						SpecItem.on("select",function(cmb,rec,id ){
							//SpecItem.load({params:{start:0,limit:cmb.pageSize,id:cmb.getValue()}});
							//UnitPersonsDs.load({params:{start:0, limit:0,id:cmb.getValue(),searchValue:"",type:type}});
						});
						
						formPanel.add(SpecItem);
						formPanel.doLayout();
					}else{
						formPanel.remove(SpecItem);
						formPanel.doLayout();
					}
				}
			}
		});
		ArcimFlagField = new Ext.form.Checkbox({
			id: 'ArcimFlag',
			fieldLabel: '增加医嘱项',
			//labelSeparator: '增加医嘱项目',
			labelSeparator: '&nbsp',
			allowBlank: true,
			checked:false,
			listeners:{
	        	"check":function(){
	        		if (this.checked==true) {
	        			SpecFlagField.setValue(false);
						ArcosFlagField.setValue(false);
						
						var RefItemData = new Ext.data.Store({
							proxy: "",
							reader: new Ext.data.JsonReader({totalProperty:"results",root:'rows'},['rowId','code','name'])
						});
						RefItem = new Ext.form.ComboBox({
							id: 'RefItem',
							fieldLabel: '关联项目',
							anchor: '90%',
							listWidth : 260,
							allowBlank: false,
							store: RefItemData,
							valueField: 'rowId',
							displayField: 'name',
							triggerAction: 'all',
							emptyText:'选择关联项目...',
							labelSeparator: '&nbsp',
							pageSize: 10,
							minChars: 1,
							selectOnFocus: true,
							forceSelection: true
						});
						RefItemData.on('beforeload', function(ds, o){
							if(Ext.getCmp('RefItem').getRawValue()=="") return false;
							ds.proxy=new Ext.data.HttpProxy({url:'dhcdocoeorderdata.csp?action=SLAArcim&searchValue='+Ext.getCmp('RefItem').getRawValue()+"&RowId="+SelNodeObj.id,method:'GET'});
						});
						RefItem.on("select",function(cmb,rec,id ){
							//RefItemData.load({params:{start:0,limit:cmb.pageSize,id:cmb.getValue()}});
							//UnitPersonsDs.load({params:{start:0, limit:0,id:cmb.getValue(),searchValue:"",type:type}});
						});
						/*SLASDateField = new Ext.ux.DateField({ //Ext.form.DateField({
							id:'SLASDate',
							fieldLabel: '开始日期',
							labelSeparator: '&nbsp',
							selectOnFocus:true,
							allowBlank: false,
							name:'SLASDate',
							emptyText:'开始日期...',
							anchor: '90%',
							format:dateFormat
						});
						SLAEDateField = new Ext.ux.DateField({ //Ext.form.DateField({
							id:'SLAEDate',
							fieldLabel: '截止日期',
							labelSeparator: '&nbsp',
							selectOnFocus:true,
							allowBlank: true,
							name:'SLAEDate',
							emptyText:'截止日期...',
							anchor: '90%',
							format:dateFormat
						});
						
						formPanel.add(RefItem,SLASDateField,SLAEDateField);*/
						formPanel.add(RefItem)
						formPanel.doLayout();
					}else{
						formPanel.remove(RefItem);
						//formPanel.remove(SLASDateField);
						//formPanel.remove(SLAEDateField);
						formPanel.doLayout();
					}
				}
			}
		});
		ArcosFlagField = new Ext.form.Checkbox({
			id: 'ArcosFlag',
			fieldLabel: '增加医嘱套',
			//labelSeparator: '增加医嘱套',
			labelSeparator: '&nbsp',
			allowBlank: true,
			checked:false,
			overCls:'' ,
			listeners:{
				"check":function(){
	        		if (this.checked==true) {
						SpecFlagField.setValue(false);
						ArcimFlagField.setValue(false);

	        			var RefARCOSItemData = new Ext.data.Store({
							proxy: "",
							reader: new Ext.data.JsonReader({totalProperty:"results",root:'rows'},['rowId','code','name'])
						});
						RefARCOSItem = new Ext.form.ComboBox({
							id: 'RefARCOSItem',
							fieldLabel: '医嘱套项目',
							labelSeparator: '&nbsp',
							anchor: '90%',
							listWidth : 260,
							allowBlank: false,
							store: RefARCOSItemData,
							valueField: 'rowId',
							displayField: 'name',
							triggerAction: 'all',
							emptyText:'选择医嘱套项目...',
							pageSize: 10,
							minChars: 1,
							selectOnFocus: true,
							forceSelection: true
						});
						RefARCOSItemData.on('beforeload', function(ds, o){
							if(Ext.getCmp('RefARCOSItem').getRawValue()=="") return false;
							ds.proxy=new Ext.data.HttpProxy({url:'dhcdocoeorderdata.csp?action=SLAArcos&searchValue='+Ext.getCmp('RefARCOSItem').getRawValue()+"&RowId="+SelNodeObj.id,method:'GET'});
						});
						RefARCOSItem.on("select",function(cmb,rec,id ){
							//RefARCOSItemData.load({params:{start:0,limit:cmb.pageSize,id:cmb.getValue()}});
							//UnitPersonsDs.load({params:{start:0, limit:0,id:cmb.getValue(),searchValue:"",type:type}});
						});
						/*SLASArcosDateField = new Ext.ux.DateField({ //Ext.form.DateField({
							id:'SLASArcosDate',
							fieldLabel: '开始日期',
							labelSeparator: '&nbsp',
							selectOnFocus:true,
							allowBlank: false,
							name:'SLASArcosDate',
							emptyText:'开始日期...',
							labelSeparator: '&nbsp',
							anchor: '90%',
							format:dateFormat
						});
						SLAEArcosDateField = new Ext.ux.DateField({ //Ext.form.DateField({
							id:'SLAEArcosDate',
							fieldLabel: '截止日期',
							labelSeparator: '&nbsp',
							selectOnFocus:true,
							allowBlank: true,
							name:'SLAEArcosDate',
							emptyText:'截止日期...',
							anchor: '90%',
							format:dateFormat
						});
						
						formPanel.add(RefARCOSItem,SLASArcosDateField,SLAEArcosDateField);*/
						formPanel.add(RefARCOSItem)
						formPanel.doLayout();
	        		}else{
	        			formPanel.remove(RefARCOSItem);
						formPanel.remove(SLASArcosDateField);
						formPanel.remove(SLAEArcosDateField);
						formPanel.doLayout();
	        		}
	        	}
	        }
		});
		//alert(SelNodeObj.attributes.SpecItem)
		if ((SelNodeObj.attributes.SpecItem)||(LeafChildNood)) {
			formPanel = new Ext.form.FormPanel({
				baseCls: 'x-plain',
				labelWidth: 90,
				items: [
					//DescField,
					//SpecFlagField,
					ArcimFlagField,
					ArcosFlagField
				]
			});
		}else{
			formPanel = new Ext.form.FormPanel({
				baseCls: 'x-plain',
				labelWidth: 90,
				items: [
					DescField,
					SpecFlagField,
					ArcimFlagField,
					ArcosFlagField
				]
			});
		}
	}else{
		//if ((FirstNode=="rootexam")||(SelNodeObj.id=="rootexam")){
		DescField = new Ext.form.TextField({
			id:'Desc',
			fieldLabel: '名称',
			selectOnFocus:true,
			allowBlank: false,
			name:'Desc',
			emptyText:'名称...',
			anchor: '90%'
		});
		ArcimFlagField = new Ext.form.Checkbox({
			id: 'ArcimFlag',
			fieldLabel: '增加医嘱项目',
			//labelSeparator: '增加医嘱项目',
			width:90,
			allowBlank: true,
			checked:false,
			listeners:{
	        	"check":function(){
	        		if (this.checked==true) {
						ArcosFlagField.setValue(false);
						
						var RefItemData = new Ext.data.Store({
							proxy: "",
							reader: new Ext.data.JsonReader({totalProperty:"results",root:'rows'},['rowId','code','name'])
						});
						RefItem = new Ext.form.ComboBox({
							id: 'RefItem',
							fieldLabel: '关联项目',
							anchor: '90%',
							listWidth : 260,
							allowBlank: false,
							store: RefItemData,
							valueField: 'rowId',
							displayField: 'name',
							triggerAction: 'all',
							emptyText:'选择关联项目...',
							pageSize: 10,
							minChars: 1,
							selectOnFocus: true,
							forceSelection: true
						});
						RefItemData.on('beforeload', function(ds, o){
							ds.proxy=new Ext.data.HttpProxy({url:'dhcdocoeorderdata.csp?action=SLAArcim&searchValue='+Ext.getCmp('RefItem').getRawValue()+"&RowId="+SelNodeObj.id,method:'GET'});
						});
						RefItem.on("select",function(cmb,rec,id ){
							//RefItemData.load({params:{start:0,limit:cmb.pageSize,id:cmb.getValue()}});
							//UnitPersonsDs.load({params:{start:0, limit:0,id:cmb.getValue(),searchValue:"",type:type}});
						});
						/*SLASDateField = new Ext.ux.DateField({ //Ext.form.DateField({
							id:'SLASDate',
							fieldLabel: '开始日期',
							selectOnFocus:true,
							allowBlank: false,
							name:'SLASDate',
							emptyText:'开始日期...',
							anchor: '90%',
							format:dateFormat,
							forceSelection: true
						});
						SLAEDateField = new Ext.ux.DateField({ //Ext.form.DateField({
							id:'SLAEDate',
							fieldLabel: '截止日期',
							selectOnFocus:true,
							allowBlank: true,
							name:'SLAEDate',
							emptyText:'截止日期...',
							anchor: '90%',
							format:dateFormat
						});
						
						formPanel.add(RefItem,SLASDateField,SLAEDateField);*/
						formPanel.add(RefItem)
						formPanel.doLayout();
					}else{
						formPanel.remove(RefItem);
						//formPanel.remove(SLASDateField);
						//formPanel.remove(SLAEDateField);
						formPanel.doLayout();
					}
				}
			}
		});
		ArcosFlagField = new Ext.form.Checkbox({
			id: 'ArcosFlag',
			fieldLabel: '增加医嘱套',
			//labelSeparator: '增加医嘱套',
			allowBlank: true,
			checked:false,
			overCls:'' ,
			listeners:{
				"check":function(){
	        		if (this.checked==true) {
						ArcimFlagField.setValue(false);

	        			var RefARCOSItemData = new Ext.data.Store({
							proxy: "",
							reader: new Ext.data.JsonReader({totalProperty:"results",root:'rows'},['rowId','code','name'])
						});
						RefARCOSItem = new Ext.form.ComboBox({
							id: 'RefARCOSItem',
							fieldLabel: '医嘱套项目',
							anchor: '90%',
							listWidth : 260,
							allowBlank: false,
							store: RefARCOSItemData,
							valueField: 'rowId',
							displayField: 'name',
							triggerAction: 'all',
							emptyText:'选择医嘱套项目...',
							pageSize: 10,
							minChars: 1,
							selectOnFocus: true,
							forceSelection: true
						});
						RefARCOSItemData.on('beforeload', function(ds, o){
							ds.proxy=new Ext.data.HttpProxy({url:'dhcdocoeorderdata.csp?action=SLAArcos&searchValue='+Ext.getCmp('RefARCOSItem').getRawValue()+"&RowId="+SelNodeObj.id,method:'GET'});
						});
						RefARCOSItem.on("select",function(cmb,rec,id ){
							//RefARCOSItemData.load({params:{start:0,limit:cmb.pageSize,id:cmb.getValue()}});
							//UnitPersonsDs.load({params:{start:0, limit:0,id:cmb.getValue(),searchValue:"",type:type}});
						});
						/*SLASArcosDateField = new Ext.ux.DateField({ //Ext.form.DateField({
							id:'SLASArcosDate',
							fieldLabel: '开始日期',
							selectOnFocus:true,
							allowBlank: false,
							name:'SLASArcosDate',
							emptyText:'开始日期...',
							anchor: '90%',
							format:dateFormat
						});
						SLAEArcosDateField = new Ext.ux.DateField({ //Ext.form.DateField({
							id:'SLAEArcosDate',
							fieldLabel: '截止日期',
							selectOnFocus:true,
							allowBlank: true,
							name:'SLAEArcosDate',
							emptyText:'截止日期...',
							anchor: '90%',
							format:dateFormat
						});
						
						formPanel.add(RefARCOSItem,SLASArcosDateField,SLAEArcosDateField);*/
						formPanel.add(RefARCOSItem)
						formPanel.doLayout();
	        		}else{
	        			formPanel.remove(RefARCOSItem);
						formPanel.remove(SLASArcosDateField);
						formPanel.remove(SLAEArcosDateField);
						formPanel.doLayout();
	        		}
	        	}
	        }
		});
		
		if (LeafChildNood) {
			formPanel = new Ext.form.FormPanel({
				baseCls: 'x-plain',
				labelWidth: 90,
				items: [
					//DescField,
					ArcimFlagField,
					ArcosFlagField
				]
			});
		}else{
			formPanel = new Ext.form.FormPanel({
				baseCls: 'x-plain',
				labelWidth: 90,
				items: [
					DescField,
					ArcimFlagField,
					ArcosFlagField
				]
			});
		}
	}
	
	
    
  // define window and show it in desktop
	windowAdd = new Ext.Window({
		title: '添加',
		iconCls:'icon-add-custom', 
		width: 400,
		height:300,
		layout: 'fit',
		plain:true,
		modal:true,
		bodyStyle:'padding:5px;',
		buttonAlign:'center',
		items: formPanel,
		buttons: [{
			text: '保存',
			iconCls:'icon-filesave-custom', 
			id:"saveButton",
			
			handler: function() { Save();}
    	},
    	{
			text: '取消',
			iconCls:'icon-undo-custom',
			handler: function(){windowAdd.close();}
		}]
    });
    windowAdd.show();
	
}
function Save(){
	var Desc="",Code="",SpecFlag="",SpecItemValue="";
	var ArcimFlag="",RefItemValue="",SLASDate="",SLAEDate="";
	var ArcosFlag="",RefARCOSItemValue="",SLASArcosDate="",SLAEArcosDate="";
	
	var SelNodeObj = treecfg.getSelectionModel().getSelectedNode();
	var RootNodeObj=SelNodeObj.getOwnerTree().root
	//var FirstNode=SelNodeObj.parentNode.id.split("||")[0];
    var FirstNode="";
	if (SelNodeObj.parentNode){
		FirstNode=SelNodeObj.parentNode.id.split("||")[0];
		if (FirstNode=="root"){
			FirstNode=SelNodeObj.id
		}
	}
	if (formPanel.form.isValid()) {
		if (DescField) Desc=DescField.getValue();
		if (CodeField &&CodeField.ownerCt) Code=CodeField.getValue();
		if (SpecFlagField&&SpecFlagField.ownerCt) SpecFlag=(SpecFlagField.getValue()==true)?'Y':'N';
		if (SpecItem&&SpecItem.ownerCt) SpecItemValue=SpecItem.getValue();
		if (ArcimFlagField&&ArcimFlagField.ownerCt) ArcimFlag=(ArcimFlagField.getValue()==true)?'Y':'N';
		if (RefItem&&RefItem.ownerCt) RefItemValue=RefItem.getValue();
		if (SLASDateField&&SLASDateField.ownerCt) SLASDate=SLASDateField.getRawValue();
		if (SLAEDateField&&SLAEDateField.ownerCt) SLAEDate=SLAEDateField.getRawValue();
		if (ArcosFlagField&&ArcosFlagField.ownerCt) ArcosFlag=(ArcosFlagField.getValue()==true)?'Y':'N';
		if (RefARCOSItem&&RefARCOSItem.ownerCt) RefARCOSItemValue=RefARCOSItem.getValue();
		if (SLASArcosDateField&&SLASArcosDateField.ownerCt) SLASArcosDate=SLASArcosDateField.getRawValue();
		if (SLAEArcosDateField&&SLAEArcosDateField.ownerCt) SLAEArcosDate=SLAEArcosDateField.getRawValue();
		
		if (!Desc||(Desc=="")){
			if (RefItemValue!="") Desc=RefItem.getRawValue();
			if (RefARCOSItemValue!="") {
				Desc=RefARCOSItem.getRawValue();
				alert("添加项目为医嘱套.");
			}
		}
		if ((CodeField&&CodeField.ownerCt)&&(Code=="")){
			alert("请务必填写代码");
			return false
		}
		if (SelNodeObj.id=="root") FirstNode=Code;
		if (SelNodeObj.id=="rootlab") FirstNode="rootlab";
		if (SelNodeObj.id=="rootexam") FirstNode="rootexam";
	    //alert('SelNodeId='+SelNodeObj.id+'&RootNodeId='+FirstNode+'&Desc='+Desc+'&SpecFlag='+SpecFlag+'&SpecItemValue='+SpecItemValue+'&ArcimFlag='+ArcimFlag+'&RefItemValue='+RefItemValue+'&SLASDate='+SLASDate+'&SLAEDate='+SLAEDate+'&ArcosFlag='+ArcosFlag+'&RefARCOSItemValue='+RefARCOSItemValue+'&SLASArcosDate='+SLASArcosDate+'&SLAEArcosDate='+SLAEArcosDate)
		//return;
		/*
		if(RefItemValue==""){
			Ext.Msg.show({title:'错误',msg:'请选择关联项目!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
			return;
		}*/
		Ext.Ajax.request({
			url: 'dhcdocoeorderdata.csp?action=Save&SelNodeId='+SelNodeObj.id+'&RootNodeId='+FirstNode+'&Desc='+escape(Desc)+'&Code='+escape(Code)+'&SpecFlag='+SpecFlag+'&SpecItemValue='+SpecItemValue+'&ArcimFlag='+ArcimFlag+'&RefItemValue='+RefItemValue+'&SLASDate='+SLASDate+'&SLAEDate='+SLAEDate+'&ArcosFlag='+ArcosFlag+'&RefARCOSItemValue='+RefARCOSItemValue+'&SLASArcosDate='+SLASArcosDate+'&SLAEArcosDate='+SLAEArcosDate,
			waitMsg:'保存中...',
			failure: function(result, request) {
				Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
			},
			success: function(result, request) {
				var jsonData = Ext.util.JSON.decode( result.responseText );
				if (jsonData.success=='true') {
					Ext.Msg.show({title:'注意',msg:'添加成功!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
					//RefItem.setValue("");
					//assLocDs.load({params:{start:0, limit:assLoc.pageSize,id:units.getValue()}});
					//dataStore.load({params:{start:0, limit:pagingTool.pageSize}});
					windowAdd.close();
					treecfg.getRootNode().reload();
				}
				else
				{
					/*
					var message=jsonData.info;
					if(message=="root")  message="部门不能添加此节点下!"
					else message="该部门已经在"+jsonData.info+"下添加!";
					//Ext.getCmp('detailReport').getNodeById(message).reload();
					*/
					Ext.Msg.show({title:'错误',msg:message,buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
				}
			},
			scope: this
		});
	}
	else{
		Ext.Msg.show({title:'错误', msg:'请修正页面提示的错误后提交。',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
	}
}
function DeleteNode(){
	var SelNodeObj = treecfg.getSelectionModel().getSelectedNode();
	var myId = "";
	if(!SelNodeObj){
		Ext.Msg.show({title:'注意',msg:'请选择需要删除的数据!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
		return;
	}else{
		Ext.MessageBox.confirm('提示', 
		'确定要删除选定的节点?', 
		function(btn) {
			if(btn == 'yes'){	
				myId = SelNodeObj.id;
				//alert(myId)
				Ext.Ajax.request({
				url:'dhcdocoeorderdata.csp?action=DelNode&myId='+myId,
				waitMsg:'删除中...',
				failure: function(result, request) {
					Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
				},
				success: function(result, request) {
					var jsonData = Ext.util.JSON.decode( result.responseText );
					if (jsonData.success=='true') {
						Ext.Msg.show({title:'注意',msg:'删除成功!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
						treecfg.getSelectionModel().clearSelections();
						treecfg.getRootNode().reload();
						//deptLevelSetsLastTabDs.load({params:{start:0, limit:deptLevelSetsPagingToolbar.pageSize}});
					}
					else{
							var message="";
							Ext.Msg.show({title:'错误',msg:message,buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
						}
					},
					scope: this
				});   	
			}
		})
	}
}

treecfg.on('movenode',function(tree,node,oldParent,newParent,index){
	   //alert(index)
		 //alert("oldParent:"+oldParent.id+"^"+oldParent.text+"^"+oldParent.getDepth()+",newParent="+newParent.id+"^"+newParent.text+"^"+newParent.getDepth())
     Ext.Ajax.request({ 
         url:'dhcdocoeorderdata.csp?action=movenode', 
         params:{ 
          nodeId:node.id, 
          oldParentId:oldParent.id, 
          newParentId:newParent.id,
          oldParentDepth:oldParent.getDepth(),
          newParentDepth:newParent.getDepth(),
          index:index 
          },
          success: function(result, request) {
				//var jsonData = Ext.util.JSON.decode( result.responseText );
				//alert("测试")
				//newParent.reload();
				//oldParent.reload();
				var newParentPath=newParent.getPath();
				var oldParentPath=oldParent.getPath();
				tree.getRootNode().reload();
				
				tree.expandPath(newParentPath);
				if (newParentPath!=oldParentPath) tree.expandPath(oldParentPath);
				//newParent.expand(true);
			},
			scope: this
      }); 
});

function UpdateNodeSort()
{
	var rootNode = treecfg.getRootNode();
	//rootNode.expand(true,true);
  var nodeList = traverseTree(rootNode);
  //alert(nodeList.children[1].children.length)
  
  return;
	treecfg.getRootNode().expand();
	getSelectedItems("")
}

/**
 * Ext 遍历 tree 的所有节点
 * @param node
 * @returns {}
 */
function traverseTree(node){
	var n = {};
	n.id = node.id;
	n.name = node.text;
	n.SpecItem = node.attributes.SpecItem;
	n.RefItem = node.attributes.RefItem;
	n.RefARCOSItem = node.attributes.RefARCOSItem;
	n.LeafDesc = node.attributes.LeafDesc;
	n.isleaf = (node.hasChildNodes()?0:1);
  
	if(node.isLeaf()){
		
	} else {
		var cds = node.childNodes;
		var arr = [];
		for (var i=0; i<cds.length; i++) {
			arr.push(traverseTree(cds[i]));
		}
		n.children = arr;
	}
	
	return n;
}

//从根节点遍历整个tree， 把叶子列出来放在一个div里面，   
function getSelectedItems(parentPath, _root){   
    if(_root){   
        var nodes = _root.childNodes;   
        if(nodes.length==0){   
         return;   
        }   
        for(var i=0; i<nodes.length; i++){   
            var div = document.createElement("div");   
            div.appendChild(document.createTextNode(parentPath + "\\" + nodes[i].text));   
            document.getElementById("selectedItems").appendChild(div);   
            if(!nodes[i].leaf){   
                //递归调用自己，以实现遍历   
                getSelectedItems(parentPath+ "\\" + nodes[i].text,  nodes[i]);   
            }   
        }   
    }   
}  

/********************************************************************/