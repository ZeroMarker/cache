Ext.ns('Ext.ux.form');		
Ext.ux.form.MultiSelectGrid = Ext.extend(Ext.form.Field,{
	delimiter: ',',
	anchor: 0,
	minMultiSelectGridections:0,
	valueField:1,
	unselectRowText: this.unselectRowText || 'Unselect All',
	unselectRowTooltip: this.unselectTooltip || 'Unselect the all item',
	unselectRowIconCls: this.unselectIconCls || 'unselectOption',	

	selectRowText: this.selectRowText || 'Select All',
	selectRowTooltip: this.selectTooltip || 'Select the all item',
	selectRowIconCls: this.selectIconCls || 'selectOption',	

	reloadText: this.reloadText || 'Reload',
	reloadTooltip: this.reloadTooltip || 'Reload the all item',
	reloadIconCls: this.reloadIconCls || 'reloadOption',		
	
	blankText:Ext.form.TextField.prototype.blankText,
	maxMultiSelectGridections:Number.MAX_VALUE,
	minMultiSelectGridectionsText: this.minMultiSelectGridectionsText || 'Minimum {0} item(s) required',
	maxMultiSelectGridectionsText: this.maxMultiSelectGridectionsText || 'Maximum {0} item(s) allowed',
	defaultAutoCreate: {
		tag: "div"
	},
	autoScroll: false,
	scroll: false,
	initComponent: function(config){
		var css = '.ux-scroll-xy {overflow-y: hidden; overflow-x: hidden;}';
		Ext.util.CSS.createStyleSheet(css);
		this.addClass('ux-scroll-xy');
		Ext.apply(this, config);
		Ext.apply(this.initialConfig, config);
		

		Ext.ux.form.MultiSelectGrid.superclass.initComponent.apply(this, arguments);
        this.addEvents({
            'dblclick' : true,
            'click' : true,
            'change' : true
        });
	},
	onRender: function(ct, position){
		Ext.ux.form.MultiSelectGrid.superclass.onRender.call(this, ct, position);
		var fs = this.fs = new Ext.form.FieldSet({
			title: this.legend,
			renderTo: this.el,
			width: this.width,
			height: this.height,
			style: "padding:0;",
			tbar: this.tbar
		});
		
		this.csm = new Ext.grid.CheckboxSelectionModel();
		this.gird = new Ext.grid.GridPanel({
			border: false,
			store: this.store,
			stripeRows: true,
			height: this.height,
			layout: 'fit',
	         viewConfig: {
                forceFit: true
            },
			hideHeaders: true,
			loadMask: true,
			autoExpandColumn: this.valueField,
			cm: new Ext.grid.ColumnModel({
				columns: [this.csm, {
					header: this.valueField,
					id: this.valueField,
					dataIndex: this.valueField
				}]
			}),
			sm: this.csm,
			bbar: [{
				text: this.selectRowText,
				tooltip: this.selectRowTooltip,
				iconCls: this.selectRowIconCls,
				scope: this,
				handler: this.selectGridRecords
			},
			'-', {
				text: this.unselectRowText,
				tooltip: this.unselectRowTooltip,
				iconCls: this.unselectRowIconCls,
				scope: this,
				handler: this.unselectGridRecords
			},
			'-', {
				text: this.reloadText,
				tooltip: this.reloadTooltip,
				iconCls: this.reloadIconCls,
				scope: this,
				handler: this.reload
			}]			
		});
		fs.add(this.gird);
		this.hiddenName = this.name || Ext.id();
		var hiddenTag = {
			tag: "input",
			type: "hidden",
			value: "",
			name: this.hiddenName
		};
        this.gird.on('click', this.onViewClick, this);
		this.hiddenField = this.el.createChild(hiddenTag);
		this.hiddenField.dom.disabled = this.hiddenName != this.name;
		fs.doLayout();
		if( this.store.proxy ) { 
		
			this.store.load();
			this.store.on('load',function(){
				if(this.value){
					this.setValue(this.value);
				}
			}, this);
		}
	},
	afterRender: function(){
		Ext.ux.form.MultiSelectGrid.superclass.afterRender.call(this);
	},
	getValue: function(){
		var ids = new Array();
		if (typeof(this.gird) != 'undefined' && this.gird.getSelectionModel().getSelected()) {
			Ext.each(this.gird.getSelectionModel().getSelections(), function(item, index){
				ids[index] = item.data[this.valueId];
			}, this);
			return ids.join(',');
		}
		return ids;
	},
	
	setValue: function(value){
		if(value != '' && value != null){
		var set = value.toString().split(',');
		this.v = set;
		this.gird.getSelectionModel().getSelections();
		Ext.each(this.gird.store.data.items, function(item, index){
			Ext.each(set, function(item1, index1){
				if (item.data[this.valueId] == item1) {
					this.gird.getSelectionModel().selectRow(index, true);
				}
			}, this);
		}, this);
		
		}
		else{
			this.gird.getSelectionModel().clearSelections();
		}
		this.hiddenField.dom.value = this.getValue();
		this.validate();
	},
	validateValue: function(value){
		if (this.getValue() != '') {
			value = this.getValue().toString().split(',');
		}
		else {
			value.length = 0;
		}
		
		if (value.length < 1){
			if (this.allowBlank) {
				this.clearInvalid();
				return true;
			}
			else {
				this.markInvalid(this.blankText);
				return false;
			}
		}
		if (value.length < this.minMultiSelectGridections) {
			this.markInvalid(String.format(this.minMultiSelectGridectionsText, this.minMultiSelectGridections));
			return false;
		}
		if (value.length > this.maxMultiSelectGridections) {
			this.markInvalid(String.format(this.maxMultiSelectGridectionsText, this.maxMultiSelectGridections));
			return false;
		}
		return true;
	},
    onViewClick: function(vw, index, node, e) {
        this.fireEvent('change', this, this.getValue(), this.hiddenField.dom.value);
        this.hiddenField.dom.value = this.getValue();
        this.fireEvent('click', this, e);
        this.validate();
    },
	disable: function(){
		this.disabled = true;
		this.hiddenField.dom.disabled = true;
		this.fs.disable();
	},
	enable: function(){
		this.disabled = false;
		this.hiddenField.dom.disabled = false;
		this.fs.enable();
	},
	reload: function(){
		if( this.store.proxy ) { 
			this.store.on('load',function(){
				if(this.v){
				this.setValue(this.v);
				}
			}, this);	
			this.store.load();
		}
	},
	unselectGridRecords: function () {
		this.gird.getSelectionModel().clearSelections();
		this.hiddenField.dom.value = this.getValue();
		this.validate();
	},
	selectGridRecords: function () {
		this.gird.getSelectionModel().selectAll();
		this.hiddenField.dom.value = this.getValue();		
		this.validate();
	}	
}); 
Ext.reg('multiselectgrid', Ext.ux.form.MultiSelectGrid);