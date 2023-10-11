Ext.namespace('Ext.BDP.Component.form');

/**
 * ComponentName: Ext.BDP.Component.form.ComboBox
 * xtype        : bdpcombo
 * extendFrom   : Ext.form.ComboBox
 * Author       : sunfengchao
 * 说明:
 * 		1、解决combox分页后，从后台获取valueField数据时，只显示id问题。
 * 		2、注意不能使用triggerAction : 'all'  allQuery : '',

 * 
 */
Ext.BDP.Component.form.ComboBox = Ext.extend(Ext.form.ComboBox, {
	
	/**
	 * 该参数用于： 根据rowid加载store
	 */
	loadByIdParam : "rowid",
	labelSeparator:"",
	forceSelection : true,
	pageSize : Ext.BDP.FunLib.PageSize.Combo,
	minChars: 0,
	onSelect : function(record, index){
        if(this.fireEvent('beforeselect', this, record, index) !== false){
            this.setValue(record.data[this.valueField || this.displayField], "selectAction");
            this.collapse();
            this.fireEvent('select', this, record, index);
        }
    },
    
	setValue : function(v, type){
        var text = v,
        _self = this;
        if(this.valueField){
        	if(type=="selectAction"){
        		var r = this.findRecord(this.valueField, v);
	            if(r){
	                text = r.data[this.displayField];
	            }else if(Ext.isDefined(this.valueNotFoundText)){
	                text = this.valueNotFoundText;
	            }
	            this.lastSelectionText = text;
		        if(this.hiddenField){
		            this.hiddenField.value = Ext.value(v, '');
		        }
		        Ext.form.ComboBox.superclass.setValue.call(this, text);
		        this.value = v;
		        return this;
        	}else{
	        	//加载store数据
	        	this.store.baseParams[this.loadByIdParam] = v;
		        this.store.load({
		            params: this.getParams(v),
		            callback: function(records, options, success){
		            	delete _self.store.baseParams[_self.loadByIdParam];
		            	
			            var r = _self.findRecord(_self.valueField, v);
			            if(r){
			                text = r.data[_self.displayField];
			            }else if(Ext.isDefined(_self.valueNotFoundText)){
			                text = _self.valueNotFoundText;
			            }
			            _self.lastSelectionText = text;
				        if(_self.hiddenField){
				            _self.hiddenField.value = Ext.value(v, '');
				        }
				        Ext.form.ComboBox.superclass.setValue.call(_self, text);
				        _self.value = v;
				        return _self;
		            }
		        });
        	}
        }else{
	        this.lastSelectionText = text;
	        if(this.hiddenField){
	            this.hiddenField.value = Ext.value(v, '');
	        }
	        Ext.form.ComboBox.superclass.setValue.call(this, text);
	        this.value = v;
	        return this;
        }
    },
	/**
	 *  查询程序 combox 下拉时进行查询操作,分 有参数 和无参数 查询二种情况
	 *  modify by sunfengchao 
	 *  2015-02-11
	 * */
	doQuery : function(q){
        q = Ext.isEmpty(q) ? '' : q;
        var qe = {
            query: q,
            combo: this,
            cancel:false
        };
        if(this.fireEvent('beforequery', qe)===false || qe.cancel){
            return false;
        }
       q = qe.query;
        //如果输入框为空,则加载第一页数据
        if(q.length==0){
                this.lastQuery = "";
                this.store.baseParams[this.queryParam] = "";
                this.store.load({
                    params: this.getParams("")
                });
                this.expand();
            
        
        }
        
        
        //如果输入的字符长度大于等于minChars,则执行查询
        if(q.length > this.minChars){
            if(this.lastQuery !== q){
                this.lastQuery = q;
                this.store.baseParams[this.queryParam] = q;
                this.store.load({
                    params: this.getParams(q)
                });
                this.expand();
            }else{
                this.selectedIndex = -1;
                this.onLoad();
            }
        }
    },
    
    onTriggerClick : function(){
        if(this.readOnly || this.disabled){
            return;
        }
        if(this.isExpanded()){
            this.collapse();
            this.el.focus();
        }else {
            this.onFocus({});
            this.doQuery(this.getRawValue());
            this.el.focus();
        }
    } 
});

Ext.reg('bdpcombo', Ext.BDP.Component.form.ComboBox);